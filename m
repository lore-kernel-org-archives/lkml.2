Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2CPFGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 01:06:11 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34153 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab2CPFGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 01:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <1331645811.25686.661.camel@gandalf.stny.rr.com>
References: <CA+jqyFAabkTRWENA5Cu8Q8O5Vc+4hmeiTS2_tduuLt2LH+mHBA@mail.gmail.com>
	<1331645811.25686.661.camel@gandalf.stny.rr.com>
Date: Fri, 16 Mar 2012 10:36:02 +0530
Message-ID: <CA+jqyFA=zEuS6gW4fKc6G9uT-PS86H70+WwORCO5uCrnLRz=Ag@mail.gmail.com>
Subject: Re: [PATCH 1/1] ftrace: fix function graph tracer
From: Rajesh Bhagat <rajesh.lnx@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=f46d0444eab74af4da04bb552ab8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0444eab74af4da04bb552ab8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello Steve,

Sorry this is the first time im doing this, so i just copied the patch
in gmail.
Please find the correct patch attached to this email, with 0
checkpatch.pl errors.

[bhagatr@linux git]$ vi 0001-ftrace-fix-function-graph-tracer.patch
(reverse-i-search)`':
[bhagatr@linux git]$ ./linux-2.6/scripts/checkpatch.pl
0001-ftrace-fix-function-graph-tracer.patch
total: 0 errors, 0 warnings, 9 lines checked

I will also try to send a V2 of this patch, as soon my "git
send-email" is up and running.

- Rajesh

On Tue, Mar 13, 2012 at 7:06 PM, Steven Rostedt <rostedt@goodmis.org> wrote=
:
>
>
> > Signed-off-by: Rajesh Bhagat <rajesh.lnx@gmail.com>
> > ---
> > =A0kernel/trace/ftrace.c | =A0 =A03 ++-
> > =A01 files changed, 2 insertions(+), 1 deletions(-)
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 683d559..dc2de98 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -219,7 +219,8 @@ static void update_ftrace_function(void)
> > =A0#else
> > =A0 =A0 __ftrace_trace_function =3D func;
> > =A0#endif
> > - =A0 ftrace_trace_function =3D ftrace_test_stop_func;
> > + =A0 ftrace_trace_function =3D
> > + =A0 =A0 =A0 (func =3D=3D ftrace_stub) ? func : ftrace_test_stop_func;
> > =A0#endif
> > =A0}
>
> BTW, this patch has major whitespace issues. It does not apply.
>
> -- Steve
>
>

--f46d0444eab74af4da04bb552ab8
Content-Type: application/octet-stream; 
	name="0001-ftrace-fix-function-graph-tracer.patch"
Content-Disposition: attachment; 
	filename="0001-ftrace-fix-function-graph-tracer.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gzurlcep0

RnJvbSAzMWY4OTcxYTE5YjQ1YWFlODIyN2M2ZDE0M2E2ZWNkZTI2ZmE2OGIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSYWplc2ggQmhhZ2F0IDxyYWplc2gubG54QGdtYWlsLmNvbT4K
RGF0ZTogRnJpLCAxNyBGZWIgMjAxMiAxMzo1OToxNSArMDUzMApTdWJqZWN0OiBbUEFUQ0ggMS8x
XSBmdHJhY2U6IGZpeCBmdW5jdGlvbiBncmFwaCB0cmFjZXIKCndoZW4gZnVuY3Rpb24gdHJhY2Vy
IGlzIHNldCAtIGZ1bmN0aW9uX2dyYXBoIHRyYWNlciBpcyBub3Qgd29ya2luZwpQcm9ibGVtIG9j
Y3VycyB3aGVuIENPTkZJR19EWU5BTUlDX0ZUUkFDRSBpcyBub3Qgc2V0CgpPdXRwdXQgYmVmb3Jl
IHBhdGNoCi9kZWJ1Zy90cmFjaW5nICMgZWNobyBmdW5jdGlvbiA+IGN1cnJlbnRfdHJhY2VyCi9k
ZWJ1Zy90cmFjaW5nICMgZWNobyBmdW5jdGlvbl9ncmFwaCA+IGN1cnJlbnRfdHJhY2VyCi9kZWJ1
Zy90cmFjaW5nICMgY2F0IHRyYWNlCgpPdXRwdXQgYWZ0ZXIgcGF0Y2gKL2RlYnVnL3RyYWNpbmcg
IyBlY2hvIGZ1bmN0aW9uID4gY3VycmVudF90cmFjZXIKL2RlYnVnL3RyYWNpbmcgIyBlY2hvIGZ1
bmN0aW9uX2dyYXBoID4gY3VycmVudF90cmFjZXIKL2RlYnVnL3RyYWNpbmcgIyBjYXQgdHJhY2UK
MCkgISAyNTMuMzc1IHVzIHwgfSAvKiBpcnFfZW50ZXIgKi8KMCkgfCBnZW5lcmljX2hhbmRsZV9p
cnEoKSB7CjApIHwgaGFuZGxlX2Zhc3Rlb2lfaXJxKCkgewowKSA5LjIwOCB1cyB8IF9yYXdfc3Bp
bl9sb2NrKCk7CjApIHwgaGFuZGxlX2lycV9ldmVudCgpIHsKMCkgfCBoYW5kbGVfaXJxX2V2ZW50
X3BlcmNwdSgpIHsKClNpZ25lZC1vZmYtYnk6IFJhamVzaCBCaGFnYXQgPHJhamVzaC5sbnhAZ21h
aWwuY29tPgotLS0KIGtlcm5lbC90cmFjZS9mdHJhY2UuYyB8ICAgIDMgKystCiAxIGZpbGVzIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJu
ZWwvdHJhY2UvZnRyYWNlLmMgYi9rZXJuZWwvdHJhY2UvZnRyYWNlLmMKaW5kZXggNjgzZDU1OS4u
ZGMyZGU5OCAxMDA2NDQKLS0tIGEva2VybmVsL3RyYWNlL2Z0cmFjZS5jCisrKyBiL2tlcm5lbC90
cmFjZS9mdHJhY2UuYwpAQCAtMjE5LDcgKzIxOSw4IEBAIHN0YXRpYyB2b2lkIHVwZGF0ZV9mdHJh
Y2VfZnVuY3Rpb24odm9pZCkKICNlbHNlCiAJX19mdHJhY2VfdHJhY2VfZnVuY3Rpb24gPSBmdW5j
OwogI2VuZGlmCi0JZnRyYWNlX3RyYWNlX2Z1bmN0aW9uID0gZnRyYWNlX3Rlc3Rfc3RvcF9mdW5j
OworCWZ0cmFjZV90cmFjZV9mdW5jdGlvbiA9CisJCShmdW5jID09IGZ0cmFjZV9zdHViKSA/IGZ1
bmMgOiBmdHJhY2VfdGVzdF9zdG9wX2Z1bmM7CiAjZW5kaWYKIH0KIAotLSAKMS43LjYKCg==
--f46d0444eab74af4da04bb552ab8--
