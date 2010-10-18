Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab0JRUus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:50:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:7615 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab0JRUur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:50:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,346,1283756400"; 
   d="p7s'?scan'208";a="337521139"
From: "Ware, Ryan R" <ryan.r.ware@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kyle McMartin <kyle@mcmartin.ca>, James Morris <jmorris@namei.org>,
        Christoph Hellwig <hch@infradead.org>,
        "kernel@lists.fedoraproject.org" <kernel@lists.fedoraproject.org>,
        Mimi Zohar <zohar@us.ibm.com>,
        "warthog9@kernel.org" <warthog9@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Serge Hallyn <serue@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Date: Mon, 18 Oct 2010 14:50:22 -0600
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Thread-Topic: ima: use of radix tree cache indexing == massive waste of
 memory?
Thread-Index: ActvBhV1B4a5BHj+QqG7zV361720Vg==
Message-ID: <C8E20010.1965B%ryan.r.ware@intel.com>
In-Reply-To: <1287408660.2516.2.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.0.0.100825
acceptlanguage: en-US
Content-Type: multipart/signed; protocol="application/pkcs7-signature";
	micalg=sha1; boundary="B_3370254622_60543"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--B_3370254622_60543
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit

On 10/18/10 6:31 AM, "Mimi Zohar" <zohar@linux.vnet.ibm.com> wrote:

>On Mon, 2010-10-18 at 20:29 +1100, Dave Chinner wrote:
>> On Sun, Oct 17, 2010 at 11:36:20PM -0700, Andrew Morton wrote:
>> > On Mon, 18 Oct 2010 02:25:30 -0400 Kyle McMartin <kyle@mcmartin.ca>
>>wrote:
>> > 
>> > > Subject: [PATCH] ima: allow it to be completely disabled (and
>>default to off)
>> > 
>> > Good enough as a short-term thing I guess.
>> > 
>> > But the memory consumption which David described is plain nuttiness
>>and
>> > needs to be fixed, presumably by using a more appropriate data
>>structure
>> > for lookups.
>> > 
>> > However unless I missed it, nobody has yet stated that they intend to
>> > fix this?
>> 
>> I think Eric said he is going to look at it.
>> 
>> Cheers,
>> 
>> Dave.
>
>Am looking at it as well.
>
>Mimi

I'll help look into this aspect too.

To be clear (since my first post seemed to go to the moderator), we will
be using this starting with MeeGo 1.2.  Yes, this rather pigish memory
usage needs to be addressed.  Let's focus on fixing that.  I'd say there
are a number of options we can explore here to do that.

It's already upstream and in the appropriate place as far as I'm
concerned.  Let's not chuck it out because on second blush there were
faults that no one expected.

Ryan

--B_3370254622_60543
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIIT7QYJKoZIhvcNAQcCoIIT3jCCE9oCAQExCzAJBgUrDgMCGgUAMAsGCSqGSIb3DQEHAaCC
EcswggX7MIIE46ADAgECAgpXoOTNAAAAABuDMA0GCSqGSIb3DQEBBQUAMFYxCzAJBgNVBAYT
AlVTMRowGAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJu
YWwgQmFzaWMgSXNzdWluZyBDQSAzQTAeFw0wODAxMDIwMzMzNDRaFw0xMTAxMDEwMzMzNDRa
MD0xFTATBgNVBAMTDFdhcmUsIFJ5YW4gUjEkMCIGCSqGSIb3DQEJARYVcnlhbi5yLndhcmVA
aW50ZWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtwe8ZzQ13qGmgXjj
zczDI4sQaFq/k2adWd/1EevQcm0PGWCgCrS3bQYoILc00wxxxgAkQvfS8Yy+RXPVHMMo966a
8io+7BytNepQtZisxgGf65psXkP+w58Az+flIredudjtRmaiyR6JaRzlhiWL2shoVFLW0mFc
iiKdN4CGlbUZPzZPxWbgZM6ZaI+YZaGQZBxhxhNIIJPixWc5fEfdI4AVFq8xtIq9boInXz1U
Qw4ZKCITqKld/cO5PRFW8nxwXlS2veplYk6hlMGV5cgwQxk7aHRYIl5LwWNAwhmB+PPkgUOr
wADBEA7JhKhDd/9Al+CRyIDAjXjxu1NKjt78NQIDAQABo4IC4jCCAt4wCwYDVR0PBAQDAgeA
MB0GA1UdDgQWBBQXZ6qTc/8S0x/pmyoEUta/6E1c5DA8BgkrBgEEAYI3FQcELzAtBiUrBgEE
AYI3FQiGw4x1hJnlUYP9gSiFjp9TgpHACWeB3r05lfBDAgFkAgEFMB8GA1UdIwQYMBaAFAlp
gTN7BnOPI0wKA9/3FoERghMFMIHJBgNVHR8EgcEwgb4wgbuggbiggbWGVGh0dHA6Ly93d3cu
aW50ZWwuY29tL3JlcG9zaXRvcnkvQ1JML0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMElz
c3VpbmclMjBDQSUyMDNBLmNybIZdaHR0cDovL2NlcnRpZmljYXRlcy5pbnRlbC5jb20vcmVw
b3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIw
M0EuY3JsMIHvBggrBgEFBQcBAQSB4jCB3zBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRl
bC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2lj
JTIwSXNzdWluZyUyMENBJTIwM0EuY3J0MHIGCCsGAQUFBzAChmZodHRwOi8vY2VydGlmaWNh
dGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRpZmljYXRlcy9JbnRlbCUyMEV4dGVybmFs
JTIwQmFzaWMlMjBJc3N1aW5nJTIwQ0ElMjAzQS5jcnQwHwYDVR0lBBgwFgYIKwYBBQUHAwQG
CisGAQQBgjcKAwwwKQYJKwYBBAGCNxUKBBwwGjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgMM
MEcGA1UdEQRAMD6gJQYKKwYBBAGCNxQCA6AXDBVyeWFuLnIud2FyZUBpbnRlbC5jb22BFXJ5
YW4uci53YXJlQGludGVsLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAl/sX41USiZeUbkm3vpDk
2gTANgJn3xcJR6IYaEznXgAQvv+OjiVHQdQF8zPpTVp6k1oEEeB9OZPW4d15vzZt8no+vLO6
4vqYkLf8j9SuMDBaRH7ZXyk+kJhBZ0hUGaOzlppna+B4FE1rXK0cfWdzNblWgiafhe5gzLbd
fHz3/6k5Mfhq/d9PL5jDYU99cmf0poLygKSRNz+eR7oZMshKqRPR4UmEYc+S4hs6qdnSErqR
o/h546jeq3DmUhtnqqeMkjczBOY/BEyVdvixkOdBgDSZASqi4BcQfVzRAQgWg8DFchSCCUpE
3+JGOo/UpeCNA/fyEj9zsM4MxJWRtUau0TCCBWMwggRLoAMCAQICCmEslIkAAAAAAAUwDQYJ
KoZIhvcNAQEFBQAwUjELMAkGA1UEBhMCVVMxGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9u
MScwJQYDVQQDEx5JbnRlbCBFeHRlcm5hbCBCYXNpYyBQb2xpY3kgQ0EwHhcNMDYwMzIyMjIy
MjQyWhcNMTIwMzIyMjIzMjQyWjBWMQswCQYDVQQGEwJVUzEaMBgGA1UEChMRSW50ZWwgQ29y
cG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgM0Ew
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCr16h/2oddLiXO2M0FIflxAzakuiLF
zsqgrYs6/cehfr+okQG73XUUSUVosX1e/Kmq0jfVjMpifdDPHPfw369csxbqveUYAgBd73b3
t8Cou5Cb+pZDCcMsgfriGHFrZY2Mdiw6m2/Uumeh3t6vFv2hir7ttyPZLDcfnJmXAzWcBnV1
SBB6RDMgOG6dEb2LX6fAbBgMp+mLiutx7oHsmHXhS/uPls9rRlKsPTloaG+qFdaAx9826C4R
yYkNqCI94wCd/y6yJM3Fj9kdtFCJYgwDwAJejDViT3bDSuRBHrsRLlEqXRbDI+awZjxx+FPI
vK1JouhhDnF+a8AMOuAM0t4BAgMBAAGjggI1MIICMTAPBgNVHRMBAf8EBTADAQH/MB0GA1Ud
DgQWBBQJaYEzewZzjyNMCgPf9xaBEYITBTALBgNVHQ8EBAMCAYYwEAYJKwYBBAGCNxUBBAMC
AQAwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwHwYDVR0jBBgwFoAUGsYMSsRHb6jbrSvw
9FYGo+03VAwwgb0GA1UdHwSBtTCBsjCBr6CBrKCBqYZOaHR0cDovL3d3dy5pbnRlbC5jb20v
cmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwUG9saWN5JTIwQ0Eu
Y3JshldodHRwOi8vY2VydGlmaWNhdGVzLmludGVsLmNvbS9yZXBvc2l0b3J5L0NSTC9JbnRl
bCUyMEV4dGVybmFsJTIwQmFzaWMlMjBQb2xpY3klMjBDQS5jcmwwgeMGCCsGAQUFBwEBBIHW
MIHTMGMGCCsGAQUFBzAChldodHRwOi8vd3d3LmludGVsLmNvbS9yZXBvc2l0b3J5L2NlcnRp
ZmljYXRlcy9JbnRlbCUyMEV4dGVybmFsJTIwQmFzaWMlMjBQb2xpY3klMjBDQS5jcnQwbAYI
KwYBBQUHMAKGYGh0dHA6Ly9jZXJ0aWZpY2F0ZXMuaW50ZWwuY29tL3JlcG9zaXRvcnkvY2Vy
dGlmaWNhdGVzL0ludGVsJTIwRXh0ZXJuYWwlMjBCYXNpYyUyMFBvbGljeSUyMENBLmNydDAN
BgkqhkiG9w0BAQUFAAOCAQEArjQp3nCfrw6V87BzszBMs+CoEzQ2yUTh2oPB/2VYGu7KHKCc
gvhyqg30IMYn1aK2020mowgRAMaoOm2zVgSeqijhR53ga15BDX+VnQ+dHgkwhVkVdxCLBxDk
NZD9HjWFeRHeIafcusAEles9s/OjuPqqLiyYqMOACIaAig/KxMg+zg4E747ywiqbFcj5RtYz
lUrDkiBdlVJrngJit0RVOJ6fN83qyv49Bt+6MIZ4hA0+mYcJFHdFy+OZ7dZu8gKTBG511Exz
Wl5xPj/fJJN5w13VtubAfucVnGEdxqYDHUImYD/39CmfsmSjRO4HKdyPzuKV6lDViLC0mE4t
7KAEdjCCAz0wggKmoAMCAQICAwWw/zANBgkqhkiG9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQ
MA4GA1UEChMHRXF1aWZheDEtMCsGA1UECxMkRXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUg
QXV0aG9yaXR5MB4XDTA2MDIxNjE4MDEzMFoXDTE2MDIxOTE4MDEzMFowUjELMAkGA1UEBhMC
VVMxGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9uMScwJQYDVQQDEx5JbnRlbCBFeHRlcm5h
bCBCYXNpYyBQb2xpY3kgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDBpd/X
Ob9QVqEZ8mQ1042TdOIq3ATDIsV2xDyt30yLyMR5Wjtus0bn3B+he89BiNO/LP6+rFzEwlD5
5PlX+HLGIKeNNG97dqyc30FElEUjZzTZFq2N4e3kVJ/XAEEgANzV8v9qp7qWwxugPgfc3z9B
kYot+CifozexHLb/hEZj+yISCU61kRZvuSQ0E11yYL4dRgcglJeaHo3oX57rvIckaLsYV5/1
Aj+R8DM1Ppk965XQAKsHfnyT7C4S50T4lVn4lz36wOdNZn/zegG1zp41lnoTFfT4KuKVJH5x
7YD1p6KbgJCKLovnujGuohquBNfdXKpZkvz6pGv+iC1HawJdAgMBAAGjgaAwgZ0wDgYDVR0P
AQH/BAQDAgEGMB0GA1UdDgQWBBQaxgxKxEdvqNutK/D0Vgaj7TdUDDA6BgNVHR8EMzAxMC+g
LaArhilodHRwOi8vY3JsLmdlb3RydXN0LmNvbS9jcmxzL3NlY3VyZWNhLmNybDAfBgNVHSME
GDAWgBRI5mj5K9KylddH2CMgEE8zmJCf1DAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEB
BQUAA4GBABMQOK2kVKVIlUWwLTdywJ+e2O+PC/uQltK2F3lRyrPfBn69tOkIP4SgDJOfsxyo
bIrPLe75kBLw+Dom13OBDp/EMZJZ1CglQfVV8co9mT3aZMjSGGQiMgkJLR3jMfr900fXZKj5
XeqCJ+JP0mEhJGEdVCY+FFlksJjV86fDrq1QMIIDIDCCAomgAwIBAgIENd70zzANBgkqhkiG
9w0BAQUFADBOMQswCQYDVQQGEwJVUzEQMA4GA1UEChMHRXF1aWZheDEtMCsGA1UECxMkRXF1
aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MB4XDTk4MDgyMjE2NDE1MVoXDTE4
MDgyMjE2NDE1MVowTjELMAkGA1UEBhMCVVMxEDAOBgNVBAoTB0VxdWlmYXgxLTArBgNVBAsT
JEVxdWlmYXggU2VjdXJlIENlcnRpZmljYXRlIEF1dGhvcml0eTCBnzANBgkqhkiG9w0BAQEF
AAOBjQAwgYkCgYEAwV2xWGcIYu6gmi0fCG2RFGiYCh7+2gRvE4RiIcPRfM6fBeC4AfBONOzi
ipUEZKzxa1NfBbPLZ4C/QgKO/t0BCezhABRP/PvwDN1Dulsr4R+AcJkVV5MW8Q+XarfCaCMc
zE1ZMKxRHjuvK9buY0V7xdlfUNLjUA86iOe/FP3gx7kCAwEAAaOCAQkwggEFMHAGA1UdHwRp
MGcwZaBjoGGkXzBdMQswCQYDVQQGEwJVUzEQMA4GA1UEChMHRXF1aWZheDEtMCsGA1UECxMk
RXF1aWZheCBTZWN1cmUgQ2VydGlmaWNhdGUgQXV0aG9yaXR5MQ0wCwYDVQQDEwRDUkwxMBoG
A1UdEAQTMBGBDzIwMTgwODIyMTY0MTUxWjALBgNVHQ8EBAMCAQYwHwYDVR0jBBgwFoAUSOZo
+SvSspXXR9gjIBBPM5iQn9QwHQYDVR0OBBYEFEjmaPkr0rKV10fYIyAQTzOYkJ/UMAwGA1Ud
EwQFMAMBAf8wGgYJKoZIhvZ9B0EABA0wCxsFVjMuMGMDAgbAMA0GCSqGSIb3DQEBBQUAA4GB
AFjOKer89961zgK5F7WF0bnj4JXMJTENAKaSbn+2kmOeUJXRmm/kEd5jhW6Y7qj/WsjTVbJm
cVfewCHrPSqnI0kBBIZCe/zuf6IWUrVnZ9NA2zsmWLIodz2uFHdh1voqZiegDfqnc1zqcPGU
IWVEX/r87yloqaKHee9570+sB3c4MYIB6jCCAeYCAQEwZDBWMQswCQYDVQQGEwJVUzEaMBgG
A1UEChMRSW50ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2lj
IElzc3VpbmcgQ0EgM0ECCleg5M0AAAAAG4MwCQYFKw4DAhoFAKBdMCMGCSqGSIb3DQEJBDEW
BBQDHe99jKCS6R4psmF9W6ETHPSp5jAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0xMDEwMTgyMDUwMjJaMA0GCSqGSIb3DQEBAQUABIIBAE+PDJryNbpZKEX3
vSAOsmBwLPuxw102yVByTEo6PQhN4vrscp/8TtSwwA+foSC4pKdf1OTqtm43qLjmXuPfJoma
J9hAiUeG8+z0KWxiX91Zzbhg6ttWPknwVOJHppcP4NnvFD+Yud4GCZsxZX2pCj0SIICXvVYN
jbLwC4OZ4WuOZdvr67sa2R23fAtpTY9k6SCUw+uO39tD77I/YWX/DvQ6CHXWGHFXKMJnPldm
IHSbmaOLnTXW05rBMa0G5r1M+DwWexfn+86ziVPnd+7bupNqjqEvP+mOGEEYZoJm5ojohz8T
jkhrTXsBQhM/ctLjLq8xbD8S8thle0gq8ffNsck=

--B_3370254622_60543--
