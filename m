Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2A3UiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:38:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:65127 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2A3UiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:38:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118190096"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
        Miles Lane <miles.lane@gmail.com>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: 3.3.0-rc1+ (Linus GIT) - iwlwifi losing connection regularly.
Thread-Topic: 3.3.0-rc1+ (Linus GIT) - iwlwifi losing connection regularly.
Thread-Index: AQHM3rcWAUwsjiXoh0OYDF4qFw62i5YlXn7AgAAB1vA=
Date: Mon, 30 Jan 2012 20:38:17 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB307C8C0@HASMSX103.ger.corp.intel.com>
References: <CAHFgRy-1519kkWwBxfe8UZMcOHqrbiq34dTX-wN5a+pd_4GPSA@mail.gmail.com>
 <5D69FF551B764E40A8245E579F3F73E602114ABC@ORSMSX102.amr.corp.intel.com>
In-Reply-To: <5D69FF551B764E40A8245E579F3F73E602114ABC@ORSMSX102.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: multipart/mixed;
	boundary="_002_0BA3FCBA62E2DC44AF3030971E174FB307C8C0HASMSX103gercorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_0BA3FCBA62E2DC44AF3030971E174FB307C8C0HASMSX103gercorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Miles,

Thanks for the detailed bug description.

>=20
> I find that with builds of Linus GIT over the last week or so I need
> to rmmod and insmod the iwlwifi driver about once every ten minutes.
> When the connection stops working, networkmanager still shows the
> connection as active, but no data is getting through (Web, pings,
> etc).
> I enabled full debug output and here is a sample of kern.log that
> stretches from a point in time when the connection was working through
> past when it failed.
> Please let me know if I can help debug this further.  I don't have
> time to do a bisection, unfortunately.
>=20

Quite a few people reported an issue that I think can be solved by the patc=
h attached.
Would you mind try and report ?
Thanks
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--_002_0BA3FCBA62E2DC44AF3030971E174FB307C8C0HASMSX103gercorpi_
Content-Type: application/octet-stream; name="tid.patch"
Content-Description: tid.patch
Content-Disposition: attachment; filename="tid.patch"; size=1998;
	creation-date="Thu, 26 Jan 2012 05:46:32 GMT";
	modification-date="Thu, 26 Jan 2012 05:47:13 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi10eC5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMKaW5kZXggZDlkNzU4ZS4u
MWI3MDA0OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWdu
LXR4LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMKQEAg
LTk1LDYgKzk1LDcgQEAgc3RhdGljIHZvaWQgaXdsYWduX3R4X2NtZF9idWlsZF9iYXNpYyhzdHJ1
Y3QgaXdsX3ByaXYgKnByaXYsCiAJCQl0eF9mbGFncyB8PSBUWF9DTURfRkxHX1NFUV9DVExfTVNL
OwogCQllbHNlCiAJCQl0eF9mbGFncyAmPSB+VFhfQ01EX0ZMR19TRVFfQ1RMX01TSzsKKwkJdHhf
Y21kLT50aWRfdHNwZWMgPSBJV0xfTUFYX1RJRF9DT1VOVDsKIAl9CiAKIAlpd2xhZ25fdHhfY21k
X3Byb3RlY3Rpb24ocHJpdiwgaW5mbywgZmMsICZ0eF9mbGFncyk7CkBAIC04MDgsNiArODA5LDgg
QEAgc3RhdGljIHZvaWQgaXdsX3J4X3JlcGx5X3R4X2FnZyhzdHJ1Y3QgaXdsX3ByaXYgKnByaXYs
CiAJdTMyIHN0YXR1cyA9IGxlMTZfdG9fY3B1KHR4X3Jlc3AtPnN0YXR1cy5zdGF0dXMpOwogCWlu
dCBpOwogCisgICAgICAgIFdBUk5fT04odGlkID09IElXTF9NQVhfVElEX0NPVU5UKTsKKwogCWlm
IChhZ2ctPndhaXRfZm9yX2JhKQogCQlJV0xfREVCVUdfVFhfUkVQTFkocHJpdiwKIAkJCSJnb3Qg
dHggcmVzcG9uc2Ugdy9vIGJsb2NrLWFja1xuIik7CkBAIC0xMDM1LDEwICsxMDM4LDEyIEBAIGlu
dCBpd2xhZ25fcnhfcmVwbHlfdHgoc3RydWN0IGl3bF9wcml2ICpwcml2LCBzdHJ1Y3QgaXdsX3J4
X21lbV9idWZmZXIgKnJ4YiwKIAkJfQogCiAJCV9fc2tiX3F1ZXVlX2hlYWRfaW5pdCgmc2ticyk7
Ci0JCXByaXYtPnRpZF9kYXRhW3N0YV9pZF1bdGlkXS5uZXh0X3JlY2xhaW1lZCA9IG5leHRfcmVj
bGFpbWVkOwogCi0JCUlXTF9ERUJVR19UWF9SRVBMWShwcml2LCAiTmV4dCByZWNsYWltZWQgcGFj
a2V0OiVkIiwKLQkJCQkJICBuZXh0X3JlY2xhaW1lZCk7CisJCWlmICh0aWQgIT0gSVdMX01BWF9U
SURfQ09VTlQpIHsKKwkJCXByaXYtPnRpZF9kYXRhW3N0YV9pZF1bdGlkXS5uZXh0X3JlY2xhaW1l
ZCA9IG5leHRfcmVjbGFpbWVkOworCQkJSVdMX0RFQlVHX1RYX1JFUExZKHByaXYsICJOZXh0IHJl
Y2xhaW1lZCBwYWNrZXQ6JWQiLAorCQkJCQkJICBuZXh0X3JlY2xhaW1lZCk7CisJCX0KIAogCQkv
KndlIGNhbiBmcmVlIHVudGlsIHNzbiAlIHEubl9iZCBub3QgaW5jbHVzaXZlICovCiAJCVdBUk5f
T04oaXdsX3RyYW5zX3JlY2xhaW0odHJhbnMocHJpdiksIHN0YV9pZCwgdGlkLCB0eHFfaWQsCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy1wY2llLmMg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy1wY2llLmMKaW5kZXggYWE4
Nzk5NC4uZmExYjM2OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2wtdHJhbnMtcGNpZS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRy
YW5zLXBjaWUuYwpAQCAtMTU1MSw3ICsxNTUxLDcgQEAgc3RhdGljIGludCBpd2xfdHJhbnNfcGNp
ZV9yZWNsYWltKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBpbnQgc3RhX2lkLCBpbnQgdGlkLAog
CiAJdHhxLT50aW1lX3N0YW1wID0gamlmZmllczsKIAotCWlmICh1bmxpa2VseSh0eHFfaWQgPj0g
SVdMQUdOX0ZJUlNUX0FNUERVX1FVRVVFICYmCisJaWYgKHVubGlrZWx5KHRpZCAhPSBJV0xfTUFY
X1RJRF9DT1VOVCAmJiB0eHFfaWQgPj0gSVdMQUdOX0ZJUlNUX0FNUERVX1FVRVVFICYmCiAJCSAg
ICAgdHhxX2lkICE9IHRyYW5zX3BjaWUtPmFnZ190eHFbc3RhX2lkXVt0aWRdKSkgewogCQkvKgog
CQkgKiBGSVhNRTogdGhpcyBpcyBhIHVDb2RlIGJ1ZyB3aGljaCBuZWVkIHRvIGJlIGFkZHJlc3Nl
ZCwK

--_002_0BA3FCBA62E2DC44AF3030971E174FB307C8C0HASMSX103gercorpi_--

