Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2IUATn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:19:43 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:54774 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225Ab2IUATl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:19:41 -0400
From: Feng Hong <hongfeng@marvell.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Sep 2012 17:16:35 -0700
Subject: RE: [PATCH V2] poweroff: fix bug in orderly_poweroff
Thread-Topic: [PATCH V2] poweroff: fix bug in orderly_poweroff
Thread-Index: Ac2XUiR/UsNkA9XHQz6kwPbL6GTJUAAOsuUg
Message-ID: <E62404B31D39064FBDD0B843ADF05A7D2D395FCD2F@SC-VEXCH4.marvell.com>
References: <1348036677-28626-1-git-send-email-hongfeng@marvell.com>
 <20120920170647.GA26278@mail.hallyn.com>
In-Reply-To: <20120920170647.GA26278@mail.hallyn.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: multipart/mixed;
	boundary="_002_E62404B31D39064FBDD0B843ADF05A7D2D395FCD2FSCVEXCH4marve_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_E62404B31D39064FBDD0B843ADF05A7D2D395FCD2FSCVEXCH4marve_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGksIFNlcmdlLA0KDQpJIGFtIGp1c3QgYSBncmFkdWF0ZSBhbmQgaXQncyBteSBmaXJzdCB0aW1l
IHRvIHNlbmQgYSBwYXRjaCB0byBvcGVuc291cmNlLCBzbyB0aGFuayB5b3UgdmVyeSBtdWNoIGZv
ciByZW1pbmRpbmcgbWUgdGhlICJjaGFuZ2Vsb2cgYWZmYWlycyIsIGl0IHNlZW1zIHRoaXMgcGF0
Y2ggaGFzIGJlZW4gYWRkZWQgdG8gLW1tIHRyZWUgYXMgYXR0YWNoZWQgbWFpbCwgYW5kIEkgaGF2
ZSBubyBjaGFuY2UgdG8gY2hhbmdlIHRoZSBjb21tZW50cywgcmlnaHQgPyBUaGVuIEkgbXVzdCBy
ZW1lbWJlciB0aGlzIGFuZCBiZSBjYXJlZnVsIG5leHQgdGltZS4gVGhhbmtzIGFnYWluIGZvciBy
ZW1pbmRpbmcgbWUgIQ0KDQo+SXMgdGhpcyBhY3R1YWxseSBzdWZmaWNpZW50IGZvciB5b3U/ICBU
aGUgZXhlYyB3aWxsIGhhdmUgc3RhcnRlZCwgYnV0IG1heSBmb3Igd2hhdGV2ZXIgKHZlcnkgdW5s
aWtlbHkpIHJlYXNvbiBmYWlsLiAgSWYgeW91J3JlIGhhcHB5IHdpdGggaXQsDQpJIHRoaW5rIFVN
SF9XQUlUX0VYRUMgaXMgc3VmZmljaWVudCBmb3IgbWUsIGFzIGluIG91ciBzeXN0ZW0gdGhlcmUg
aXMgbm8gIi9zYmluL3Bvd2Vyb2ZmIiBleGlzdGVkLiBPbiB0aGUgb3RoZXIgaGFuZCwgVU1IX1dB
SVRfUFJPQyBpcyBub3Qgc3VpdGFibGUgaGVyZSBhcyBFcmljIGFuYWx5c2lzOyBpZiB1c2luZyBV
TUhfV0FJVF9FWEVDLCBhbmQgdGhlIHVzZXIgYXBwbGljYXRpb24gZmFpbCwgSSdkIHByZWZlciB0
byBjb21wbGFpbiBiYWQgYXBwbGljYXRpb24uIFNvIHVzaW5nIFVNSF9XQUlUX0VYRUMgYW5kIFVN
SF9XQUlUX1BST0MgaGFzIGEgdHJhZGVvZmYgaGVyZSwgd2hhdCBkbyB5b3UgdGhpbmsgc28gPw0K
DQotLQ0KQmVzdCBSZWdhcmRzLA0KRmVuZyBIb25nDQpBcHBsaWNhdGlvbiBQcm9jZXNzb3IgU29m
dHdhcmUgRW5nbmllZXIgDQpNYXJ2ZWxsIFRlY2hub2xvZ3kgKFNoYW5naGFpKSBMdGQNCg0KLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFNlcmdlIEUuIEhhbGx5biBbbWFpbHRvOnNl
cmdlQGhhbGx5bi5jb21dIA0KU2VudDogMjAxMsTqOdTCMjHI1SAxOjA3DQpUbzogRmVuZyBIb25n
DQpDYzogYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsgZ29yY3Vub3ZAb3BlbnZ6Lm9yZzsga2Vl
c2Nvb2tAY2hyb21pdW0ub3JnOyBzZXJnZS5oYWxseW5AY2Fub25pY2FsLmNvbTsgZWJpZWRlcm1A
eG1pc3Npb24uY29tOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBSZTog
W1BBVENIIFYyXSBwb3dlcm9mZjogZml4IGJ1ZyBpbiBvcmRlcmx5X3Bvd2Vyb2ZmDQoNClF1b3Rp
bmcgaG9uZ2ZlbmcgKGhvbmdmZW5nQG1hcnZlbGwuY29tKToNCj4gb3JkZXJseV9wb3dlcm9mZiBp
cyB0cnlpbmcgdG8gcG93ZXJvZmYgcGxhdGZvcm0gYnkgdHdvIHN0ZXBzOg0KPiBzdGVwIDE6IENh
bGwgdXNlcnNwYWNlIGFwcGxpY2F0aW9uIHRvIHBvd2Vyb2ZmDQo+IHN0ZXAgMjogSWYgdXNlcnNw
YWNlIHBvd2Vyb2ZmIGZhaWwsIHRoZW4gZG8gYSBmb3JjZSBwb3dlciBvZmYgaWYgZm9yY2UgcGFy
YW0gaXMgc2V0Lg0KPiANCj4gVGhlIGJ1ZyBoZXJlIGlzLCBzdGVwIDEgaXMgYWx3YXlzIHN1Y2Nl
c3NmdWwgd2l0aCBwYXJhbSBVTUhfTk9fV0FJVCwNCg0KTm90ZSB0aGF0IGEgY2hhbmdlbG9nIGhl
cmUgZXhwbGFpbmluZyB0aGF0IHlvdSBzd2l0Y2hlZCB0byBVTUhfV0FJVF9FWEVDDQpwZXIgRXJp
YydzIHN1Z2dlc3Rpb24gd291bGQgYmUgYm90aCBpbmZvcm1hdGl2ZSBhbmQgY291cnRlb3VzLg0K
DQo+IHNob3VsZCBjaGFuZ2UgdG8gVU1IX1dBSVRfRVhFQyB3aGljaCB3aWxsIG1vbml0b3Igd2hl
dGhlciB1c2VyIGFwcGxpY2F0aW9uIHN1Y2Nlc3NmdWwgcnVuLg0KDQpJcyB0aGlzIGFjdHVhbGx5
IHN1ZmZpY2llbnQgZm9yIHlvdT8gIFRoZSBleGVjIHdpbGwgaGF2ZSBzdGFydGVkLCBidXQNCm1h
eSBmb3Igd2hhdGV2ZXIgKHZlcnkgdW5saWtlbHkpIHJlYXNvbiBmYWlsLiAgSWYgeW91J3JlIGhh
cHB5IHdpdGgNCml0LA0KDQpBY2tlZC1ieTogU2VyZ2UgSGFsbHluIDxzZXJnZS5oYWxseW5AY2Fu
b25pY2FsLmNvbT4NCg0KPiBDaGFuZ2UtSWQ6IEkyZjllYmJiOTBjMGMyNDQzNzgwMDgwZWM5NTA3
YzhkMDA0ZTVkYTc0DQo+IFNpZ25lZC1vZmYtYnk6IEZlbmcgSG9uZyA8aG9uZ2ZlbmdAbWFydmVs
bC5jb20+DQo+IEFja2VkLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4NCj4g
LS0tDQo+ICBrZXJuZWwvc3lzLmMgfCAgICAyICstDQo+ICAxIGZpbGVzIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvc3lz
LmMgYi9rZXJuZWwvc3lzLmMNCj4gaW5kZXggMjQxNTA3Zi4uYTYyNGQ0YyAxMDA2NDQNCj4gLS0t
IGEva2VybmVsL3N5cy5jDQo+ICsrKyBiL2tlcm5lbC9zeXMuYw0KPiBAQCAtMjIwNCw3ICsyMjA0
LDcgQEAgc3RhdGljIGludCBfX29yZGVybHlfcG93ZXJvZmYodm9pZCkNCj4gIAkJcmV0dXJuIC1F
Tk9NRU07DQo+ICAJfQ0KPiAgDQo+IC0JcmV0ID0gY2FsbF91c2VybW9kZWhlbHBlcl9mbnMoYXJn
dlswXSwgYXJndiwgZW52cCwgVU1IX05PX1dBSVQsDQo+ICsJcmV0ID0gY2FsbF91c2VybW9kZWhl
bHBlcl9mbnMoYXJndlswXSwgYXJndiwgZW52cCwgVU1IX1dBSVRfRVhFQywNCj4gIAkJCQkgICAg
ICBOVUxMLCBhcmd2X2NsZWFudXAsIE5VTEwpOw0KPiAgCWlmIChyZXQgPT0gLUVOT01FTSkNCj4g
IAkJYXJndl9mcmVlKGFyZ3YpOw0KPiAtLSANCj4gMS43LjAuNA0KPiANCj4gLS0NCj4gVG8gdW5z
dWJzY3JpYmUgZnJvbSB0aGlzIGxpc3Q6IHNlbmQgdGhlIGxpbmUgInVuc3Vic2NyaWJlIGxpbnV4
LWtlcm5lbCIgaW4NCj4gdGhlIGJvZHkgb2YgYSBtZXNzYWdlIHRvIG1ham9yZG9tb0B2Z2VyLmtl
cm5lbC5vcmcNCj4gTW9yZSBtYWpvcmRvbW8gaW5mbyBhdCAgaHR0cDovL3ZnZXIua2VybmVsLm9y
Zy9tYWpvcmRvbW8taW5mby5odG1sDQo+IFBsZWFzZSByZWFkIHRoZSBGQVEgYXQgIGh0dHA6Ly93
d3cudHV4Lm9yZy9sa21sLw0K

--_002_E62404B31D39064FBDD0B843ADF05A7D2D395FCD2FSCVEXCH4marve_
Content-Type: message/rfc822

Received: from psmtp.com (74.125.149.98) by sc-owa01.marvell.com (10.93.76.21)
 with Microsoft SMTP Server id 8.3.213.0; Wed, 19 Sep 2012 12:12:43 -0700
Received: from mail-bk0-f74.google.com ([209.85.214.74]) (using TLSv1) by
 na3sys009amx172.postini.com ([74.125.148.10]) with SMTP;	Wed, 19 Sep 2012
 12:12:43 PDT
Received: by bkcjc3 with SMTP id jc3so77872bkc.5        for
 <hongfeng@marvell.com>; Wed, 19 Sep 2012 12:12:41 -0700 (PDT)
Received: by 10.180.106.199 with SMTP id gw7mr1144783wib.0.1348081961502;
        Wed, 19 Sep 2012 12:12:41 -0700 (PDT)
Received: from hpza10.eem.corp.google.com ([74.125.121.33])        by
 gmr-mx.google.com with ESMTPS id fb20si2597379wid.3.2012.09.19.12.12.41
        (version=TLSv1/SSLv3 cipher=AES128-SHA);        Wed, 19 Sep 2012
 12:12:41 -0700 (PDT)
Received: from localhost.localdomain (akpm.mtv.corp.google.com [172.18.96.75])
	by hpza10.eem.corp.google.com (Postfix) with ESMTP id 2DDC120004E;	Wed, 19
 Sep 2012 12:12:40 -0700 (PDT)
From: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
To: "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>
CC: Feng Hong <hongfeng@marvell.com>, "ebiederm@xmission.com"
	<ebiederm@xmission.com>, "keescook@chromium.org" <keescook@chromium.org>,
	"rjw@sisk.pl" <rjw@sisk.pl>, "serge.hallyn@canonical.com"
	<serge.hallyn@canonical.com>
Date: Wed, 19 Sep 2012 12:12:39 -0700
Subject: + poweroff-fix-bug-in-orderly_poweroff.patch added to -mm tree
Thread-Topic: + poweroff-fix-bug-in-orderly_poweroff.patch added to -mm tree
Thread-Index: Ac2Wmr8bdW2D4x2bSA+9H7NqJvO+rw==
Message-ID: <20120919191240.2DDC120004E@hpza10.eem.corp.google.com>
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: SC-OWA01.marvell.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-pstn-settings: 3 (1.0000:0.0100) s cv GT3 gt2 gt1 r p m c 
x-pstn-levels: (S:99.90000/99.90000 CV:99.9000 FC:95.5390 LC:95.5390
 R:95.9108 P:95.9108 M:97.0282 C:98.6951 )
x-pstn-addresses: from <akpm@linux-foundation.org> [db-null] 
x-pstn-neptune: 0/0/0.00/0
x-pstn-dkim: 0 skipped:not-enabled
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0


The patch titled
     Subject: poweroff: fix bug in orderly_poweroff()
has been added to the -mm tree.  Its filename is
     poweroff-fix-bug-in-orderly_poweroff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code **=
*

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: hongfeng <hongfeng@marvell.com>
Subject: poweroff: fix bug in orderly_poweroff()

orderly_poweroff is trying to poweroff platform by two steps:

step 1: Call userspace application to poweroff

step 2: If userspace poweroff fail, then do a force power off if force
param is set.

The bug here is, step 1 is always successful with param UMH_NO_WAIT,
should change to UMH_WAIT_EXEC which will monitor whether user application
successful run.

Signed-off-by: Feng Hong <hongfeng@marvell.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~poweroff-fix-bug-in-orderly_poweroff kernel/sys.c
--- a/kernel/sys.c~poweroff-fix-bug-in-orderly_poweroff
+++ a/kernel/sys.c
@@ -2205,7 +2205,7 @@ static int __orderly_poweroff(void)
                return -ENOMEM;
        }

-       ret =3D call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
+       ret =3D call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
                                      NULL, argv_cleanup, NULL);
        if (ret =3D=3D -ENOMEM)
                argv_free(argv);
_

Patches currently in -mm which might be from hongfeng@marvell.com are

poweroff-fix-bug-in-orderly_poweroff.patch


--_002_E62404B31D39064FBDD0B843ADF05A7D2D395FCD2FSCVEXCH4marve_--
