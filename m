Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab1IWVFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 17:05:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48156 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1IWVFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 17:05:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwVrvMa1z7P5q0kUN3QAwZzTdL1mhLaF7+etHYQm511vA@mail.gmail.com>
References: <1316809586-28529-1-git-send-email-acme@infradead.org> <CA+55aFwVrvMa1z7P5q0kUN3QAwZzTdL1mhLaF7+etHYQm511vA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Sep 2011 14:05:25 -0700
X-Google-Sender-Auth: 8B4OVOPyycn7vLIhRSZsDGnB3CI
Message-ID: <CA+55aFysPyDCjs3MTwHBRWVq5OTU=-aWCRiJP=VZL-EdCGNU0w@mail.gmail.com>
Subject: Re: [GIT PULL 00/12] perf tools fixes
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yrl.pp-manager.tt@hitachi.com,
        arnaldo.melo@gmail.com
Content-Type: multipart/mixed; boundary=20cf307cfece39324b04ada22c8f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf307cfece39324b04ada22c8f
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Sep 23, 2011 at 2:03 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But it obviously doesn't affect the kernel compile. It *does* affect
> the perf tool compile, and util/python.c no longer compiles because
> the byte-swap flag isn't passed to it.

This stupid patch makes it compile. But see the comment..

                 Linus

--20cf307cfece39324b04ada22c8f
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsxntdot0

IHRvb2xzL3BlcmYvdXRpbC9weXRob24uYyB8ICAgIDMgKystCiAxIGZpbGVzIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS90b29scy9wZXJmL3V0
aWwvcHl0aG9uLmMgYi90b29scy9wZXJmL3V0aWwvcHl0aG9uLmMKaW5kZXggY2JjOGYyMTVkNGI3
Li4wZDUwMjc3OTM2ZjUgMTAwNjQ0Ci0tLSBhL3Rvb2xzL3BlcmYvdXRpbC9weXRob24uYworKysg
Yi90b29scy9wZXJmL3V0aWwvcHl0aG9uLmMKQEAgLTgwMyw3ICs4MDMsOCBAQCBzdGF0aWMgUHlP
YmplY3QgKnB5cmZfZXZsaXN0X19yZWFkX29uX2NwdShzdHJ1Y3QgcHlyZl9ldmxpc3QgKnBldmxp
c3QsCiAJCWZpcnN0ID0gbGlzdF9lbnRyeShldmxpc3QtPmVudHJpZXMubmV4dCwgc3RydWN0IHBl
cmZfZXZzZWwsIG5vZGUpOwogCQllcnIgPSBwZXJmX2V2ZW50X19wYXJzZV9zYW1wbGUoZXZlbnQs
IGZpcnN0LT5hdHRyLnNhbXBsZV90eXBlLAogCQkJCQkgICAgICAgcGVyZl9ldnNlbF9fc2FtcGxl
X3NpemUoZmlyc3QpLAotCQkJCQkgICAgICAgc2FtcGxlX2lkX2FsbCwgJnBldmVudC0+c2FtcGxl
KTsKKwkJCQkJICAgICAgIHNhbXBsZV9pZF9hbGwsICZwZXZlbnQtPnNhbXBsZSwKKwkJCQkJICAg
ICAgIDAgLyogcmVhbGx5PyAqLyk7CiAJCWlmIChlcnIpCiAJCQlyZXR1cm4gUHlFcnJfRm9ybWF0
KFB5RXhjX09TRXJyb3IsCiAJCQkJCSAgICAicGVyZjogY2FuJ3QgcGFyc2Ugc2FtcGxlLCBlcnI9
JWQiLCBlcnIpOwo=
--20cf307cfece39324b04ada22c8f--
