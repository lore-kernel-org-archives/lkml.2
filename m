Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2KLRXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:23:52 -0500
Received: from pilot.jhuapl.edu ([128.244.251.36]:56551 "EHLO jhuapl.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751682Ab2KLRXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:23:51 -0500
Message-ID: <50A13039.2070909@jhuapl.edu>
Date: Mon, 12 Nov 2012 12:22:01 -0500
From: Matthew Fioravante <matthew.fioravante@jhuapl.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "key@linux.vnet.ibm.com" <key@linux.vnet.ibm.com>,
        "mail@srajiv.net" <mail@srajiv.net>,
        "tpmdd@selhorst.net" <tpmdd@selhorst.net>,
        "tpmdd@sirrix.com" <tpmdd@sirrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2] add xen-tpmfront.ko: Xen Virtual TPM frontend driver
References: <1352730598-13904-1-git-send-email-matthew.fioravante@jhuapl.edu> <20121112163052.GA9575@phenom.dumpdata.com>
In-Reply-To: <20121112163052.GA9575@phenom.dumpdata.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090603020802090608070101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090603020802090608070101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/12/2012 11:30 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Nov 12, 2012 at 09:29:58AM -0500, Matthew Fioravante wrote:
>> This patch ports the xen vtpm frontend driver for linux
>> from the linux-2.6.18-xen.hg tree to linux-stable. This
>> driver is designed be used with the mini-os tpmback driver
>> in Xen as part of the new mini-os virtual tpm subsystem.
>> See docs/misc/vtpm.txt in Xen and the xen-devel mailing list
>> for details.
> I didn't look in details but off the bat - you are missing
> the Documentation/../sysfs file.
It looks like Kent submitted a patch that documents sysfs generically
for all of the TPM drivers.
>
> I still think you should include the full vtpm.txt in this
> patch description and refer at the end to the docs/misc/vtpm.txt
> in Xen as the source for the up-to-date version.
The current docs/misc/vtpm.txt in Xen is still the old version. I've=20
just written a new one and am reviewing it. It will come in the next=20
resubmission of my vtpm patches to xen. I'll include the text here for=20
the next resubmission of this patch as well.



--------------ms090603020802090608070101
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIDyjCC
A8YwggMvoAMCAQICBD/xyf0wDQYJKoZIhvcNAQEFBQAwLzELMAkGA1UEBhMCVVMxDzANBgNV
BAoTBkpIVUFQTDEPMA0GA1UECxMGQklTRENBMB4XDTEwMDYxMTE4MjIwNloXDTEzMDYxMTE4
NTIwNlowZjELMAkGA1UEBhMCVVMxDzANBgNVBAoTBkpIVUFQTDEPMA0GA1UECxMGUGVvcGxl
MTUwFgYDVQQLEw9WUE5Hcm91cC1CSVNEQ0EwGwYDVQQDExRNYXR0aGV3IEUgRmlvcmF2YW50
ZTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAnpbwVSP6o1Nb5lcW7dd3yTo9iBJdi7qz
4nANOMFPK7JOy5npKN1iiousl28U/scUJES55gPwAWYJK3uVyQAsA4adgDKi5DoD1UHDQEwp
bY7iHLJeq0NPr4BqYNqnCFPbE6HC8zSJrr4qKn+gVUQT39SIFqdiIPJwZL8FYTRQ/zsCAwEA
AaOCAbYwggGyMAsGA1UdDwQEAwIHgDArBgNVHRAEJDAigA8yMDEwMDYxMTE4MjIwNlqBDzIw
MTIwNzE3MjI1MjA2WjAbBg0rBgEEAbMlCwMBAQEBBAoWCGZpb3JhbWUxMBsGDSsGAQQBsyUL
AwEBAQIEChIIMDAxMDQyNjEwWAYJYIZIAYb6ax4BBEsMSVRoZSBwcml2YXRlIGtleSBjb3Jy
ZXNwb25kaW5nIHRvIHRoaXMgY2VydGlmaWNhdGUgbWF5IGhhdmUgYmVlbiBleHBvcnRlZC4w
KAYDVR0RBCEwH4EdTWF0dGhldy5GaW9yYXZhbnRlQGpodWFwbC5lZHUwUgYDVR0fBEswSTBH
oEWgQ6RBMD8xCzAJBgNVBAYTAlVTMQ8wDQYDVQQKEwZKSFVBUEwxDzANBgNVBAsTBkJJU0RD
QTEOMAwGA1UEAxMFQ1JMNTYwHwYDVR0jBBgwFoAUCDUpmxH52EU2CyWmF2EJMB1yqeswHQYD
VR0OBBYEFO6LYxg6r9wHZ+zdQtBHn1dZ/YTNMAkGA1UdEwQCMAAwGQYJKoZIhvZ9B0EABAww
ChsEVjcuMQMCBLAwDQYJKoZIhvcNAQEFBQADgYEAJO9HQh4YNChVLzuZqK5ARJARD8JoujGZ
fdo75quvg2jXFQe2sEjvLnxJZgm/pv8fdZakq48CWwjYHKuvIp7sDjTEsQfo+y7SpN/N2NvJ
WU5SqfK1VgYtNLRRoGJUB5Q1aZ+Dg95g3kqpyfpUMISJL8IKVLtJVfN4fggFVUYZ9wwxggGr
MIIBpwIBATA3MC8xCzAJBgNVBAYTAlVTMQ8wDQYDVQQKEwZKSFVBUEwxDzANBgNVBAsTBkJJ
U0RDQQIEP/HJ/TAJBgUrDgMCGgUAoIHLMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTEyMTExMjE3MjIwMVowIwYJKoZIhvcNAQkEMRYEFJPFWr9ZfnF3BcET
68Yq5ttbLCTXMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBAjAK
BggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYI
KoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEgYAiOHtiOdqTXHNXAiT2HsZrKtOVBHbLCTYw
BOTGpj5qE1z8YKYBDWVVIRe3arLR98f+lqSJLzcOBeZs9CTRqnv1lXr+3Bz2rNK7BfUgd22r
P2zISikZD0++9X0goPilRbGw6UHL0N2wxF107d0PcowQ+SEvskqslkDFiPtwwv39pwAAAAAA
AA==
--------------ms090603020802090608070101--
