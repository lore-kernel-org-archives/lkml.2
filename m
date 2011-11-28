Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1K1Rtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 12:49:35 -0500
Received: from node6.gecad.com ([193.230.245.6]:57176 "EHLO node6.gecad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab1K1Rte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 12:49:34 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 12:49:33 EST
Message-ID: <4ED3C87D.5010400@avangate.com>
Date: Mon, 28 Nov 2011 19:44:29 +0200
From: Valentin Avram <valentin.avram@avangate.com>
Reply-To: Valentin AVRAM <valentin.avram@avangate.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111121 Thunderbird/8.0
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: Oops in fsnotify_mark (2.6.37, 3.0.6)
Content-Type: multipart/signed; protocol="application/pkcs7-signature";	micalg=sha1;
 boundary="------------ms080807010901050309030700"
X-Originating-IP: [10.5.5.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------ms080807010901050309030700
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hello.

Some of our servers experience an oops on auditd service restart.
All affected servers are Dell R610, running Gentoo Linux with kernels=20
2.6.37 and 3.0.6 (both gentoo patched).
After repeated auditd restarts, the kernel also logs warnings and=20
finally the machine goes unresponsive with the kernel logging on the=20
console CPU stalls.

The affected kernels are a 2.6.37 and a 3.0.6 (gentoo-sources package).

The 2.6.37-r4-gentoo kernel is basically kernel 2.6.37 + patches from=20
mpagano from here:
http://dev.gentoo.org/~mpagano/genpatches/patches-2.6.37-6.htm
(
aka
http://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-2.6.37-6.ba=
se.tar.bz2
http://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-2.6.37-6.ex=
tras.tar.bz2
)

The 3.0.6-gentoo kernel is also the 3.0.6 kernel + mpagano patches from=20
here:
http://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-3.0-8.base.=
tar.bz2
http://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-3.0-8.extra=
s.tar.bz2

The oops seems to happen at random when restarting the auditd 2.1.3=20
(latest) daemon. Before the crash i can see the [fsnotify_mark] kernel=20
thread, after the oops it is no more.

More data (kernel configs, oops and warning data, dmesg with=20
CONFIG_DEBUG_INFO and CONFIG_DEBUG_LIST enabled, screenshots etc) can be =

found on the following Gentoo bug:
https://bugs.gentoo.org/show_bug.cgi?id=3D389405

Since the activity on the Gentoo bug thread is slow, maybe somebody from =

here has seen anything similar or has any idea what to do/test next.

Thank you for your time.



--------------ms080807010901050309030700
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIG8DCC
BuwwggXUoAMCAQICCkXjPh0AAQAADegwDQYJKoZIhvcNAQEFBQAwQzEVMBMGCgmSJomT8ixk
ARkWBWxvY2FsMRcwFQYKCZImiZPyLGQBGRYHZ2VjYWRjbzERMA8GA1UEAxMIR2VDQUQgQ0Ew
HhcNMTEwMzAyMTQxOTE4WhcNMTIwMzAxMTQxOTE4WjCBvDEVMBMGCgmSJomT8ixkARkWBWxv
Y2FsMRcwFQYKCZImiZPyLGQBGRYHZ2VjYWRjbzEOMAwGA1UECxMFR2VDQUQxEjAQBgNVBAsT
CUNvbXBhbmllczERMA8GA1UECxMIRXBheW1lbnQxDjAMBgNVBAsTBVVzZXJzMRcwFQYDVQQD
Ew5WYWxlbnRpbiBBVlJBTTEqMCgGCSqGSIb3DQEJARYbdmFsZW50aW4uYXZyYW1AYXZhbmdh
dGUuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvic205+/aW+5FXUJcfin
8hfS3qJueL/R2/CokcHOidKrawJWGIJfjMeKL+KV9gGWTza3enLxQgztOgnQKKg8urYQGxMo
PkOiLatGpb4C9o6uVrYWgovQd68vU4f1WksT5c6gx1yCuJoVqOBIxaW8gR9f69i5wSN9hyVp
bhq6sjJsgqXz1+4z95ZRAKGkGoZAsgAMDNaUPztlKxeLu3PJeQxUNHLFKne5YAq2BG7ytU2Y
pPicLmSmUzubIAM2b3BNm6tX1m4SSCH8DRNXcdVLIjFcv2u8Hhj04DHFxOVIetgZYFuKgC1Q
JSq0AK0GDUKqKz9nEgN/sxKtXLiaQxBO/wIDAQABo4IDZjCCA2IwHQYDVR0OBBYEFEvvL1U5
tlQF4A+b4+sbrX/4sdPHMB8GA1UdIwQYMBaAFHEpqLRyBAugwWJ1jFDmXqv9LsuqMIIBAgYD
VR0fBIH6MIH3MIH0oIHxoIHuhoGzbGRhcDovLy9DTj1HZUNBRCUyMENBLENOPWdlY2FkMDEs
Q049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZp
Z3VyYXRpb24sREM9Z2VjYWRjbyxEQz1sb2NhbD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
P2Jhc2U/b2JqZWN0Q2xhc3M9Y1JMRGlzdHJpYnV0aW9uUG9pbnSGNmh0dHA6Ly9nZWNhZDAx
LmdlY2FkY28ubG9jYWwvQ2VydEVucm9sbC9HZUNBRCUyMENBLmNybDCCAR0GCCsGAQUFBwEB
BIIBDzCCAQswgasGCCsGAQUFBzAChoGebGRhcDovLy9DTj1HZUNBRCUyMENBLENOPUFJQSxD
Tj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9u
LERDPWdlY2FkY28sREM9bG9jYWw/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNl
cnRpZmljYXRpb25BdXRob3JpdHkwWwYIKwYBBQUHMAKGT2h0dHA6Ly9nZWNhZDAxLmdlY2Fk
Y28ubG9jYWwvQ2VydEVucm9sbC9nZWNhZDAxLmdlY2FkY28ubG9jYWxfR2VDQUQlMjBDQSgx
KS5jcnQwFwYJKwYBBAGCNxQCBAoeCABVAHMAZQByMAwGA1UdEwEB/wQCMAAwCwYDVR0PBAQD
AgWgMCkGA1UdJQQiMCAGCisGAQQBgjcKAwQGCCsGAQUFBwMEBggrBgEFBQcDAjBUBgNVHREE
TTBLoCwGCisGAQQBgjcUAgOgHgwcdmFsZW50aW4uYXZyYW1AZ2VjYWRjby5sb2NhbIEbdmFs
ZW50aW4uYXZyYW1AYXZhbmdhdGUuY29tMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwIC
AgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzANBgkqhkiG9w0BAQUF
AAOCAQEAfXxzfVWpUjNftVoTwVOW6PCN9OrLdId82CjOATQpHOVsNcDuDjEcKXLbF2UbJ++G
+y/yPzzlnUTyuV3fsuC7y/UN3oTfUTjR5CjbsiCe1q1JymkNEsZqn7q6QuXdu1oy6QhWjIKB
r+avvQL/kOSN/R1Zq0ad/k6XE90gyW87tfI4SoDEFGQ6evIypbEu8ugwwEJLRPASqpHRZMgx
Xvohx1gOkoguXbLGaymx7jQNQyD5O6X/1MsK3lI77yxVWOSapA7B4rlKI03/lcg0kCwtfTD4
V3w7IPeGlKytikmxTCFi1ZvHJ+nIzmtEcAThRCRJVWjkDSgNhkfUgUAvy6eKMTGCAwAwggL8
AgEBMFEwQzEVMBMGCgmSJomT8ixkARkWBWxvY2FsMRcwFQYKCZImiZPyLGQBGRYHZ2VjYWRj
bzERMA8GA1UEAxMIR2VDQUQgQ0ECCkXjPh0AAQAADegwCQYFKw4DAhoFAKCCAYQwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTExMTI4MTc0NDI5WjAjBgkq
hkiG9w0BCQQxFgQUcbYz/3QjbcmIr9CqRAhcBv5///YwXwYJKoZIhvcNAQkPMVIwUDALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMGAGCSsGAQQBgjcQBDFTMFEwQzEVMBMGCgmSJomT8ixk
ARkWBWxvY2FsMRcwFQYKCZImiZPyLGQBGRYHZ2VjYWRjbzERMA8GA1UEAxMIR2VDQUQgQ0EC
CkXjPh0AAQAADegwYgYLKoZIhvcNAQkQAgsxU6BRMEMxFTATBgoJkiaJk/IsZAEZFgVsb2Nh
bDEXMBUGCgmSJomT8ixkARkWB2dlY2FkY28xETAPBgNVBAMTCEdlQ0FEIENBAgpF4z4dAAEA
AA3oMA0GCSqGSIb3DQEBAQUABIIBALb4pQlGChPFjrX+2sDFz6uF2+C7xBD3Wt5wI+11SCj/
M7w+ZKPw42FzxQY8mESU6ATbrxsHxXlxHFfPbvg9bReUaMpVqkvnpM0qV380Qg6El2pawuVV
54Zi/M9/CXjEg0LKtFlwYKpcyBdNVEpURABSdsE32xA8oDvTpUXCBM/CB3y+jHvQ6ZZELbGQ
Ts9DqPX+icBwXJ/3HCbNldFZVFjFbiDPR5x13vUqjuXDzH0cQ8Gg8cInbVc5SRXHXMN83hpN
9clF4gMVR/4kL/2sIPuE+lI7uq0pOuukgh2LKVYN5/rV8Ws/T18MrqbNyu5xFlRXMz5YQj6a
ij5etFUX+c8AAAAAAAA=
--------------ms080807010901050309030700--
