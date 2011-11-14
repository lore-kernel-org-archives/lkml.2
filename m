Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1KNAMC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:12:02 -0500
Received: from mailgw02.dd24.net ([193.46.215.43]:39029 "EHLO
	mailgw02.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1KNAMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:12:00 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Nov 2011 19:11:59 EST
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20110908084913.GB2195@redhat.com>
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
	 <20110902233806.GA22157@elie> <20110905091918.GC2221@redhat.com>
	 <265f56a4dc9f5d3edeca3d101e445353@imap.dd24.net>
	 <20110908084913.GB2195@redhat.com>
Content-Type: multipart/signed; micalg="sha1"; protocol="application/x-pkcs7-signature"; boundary="=-HBLg9lit2NnK8ge86ZhI"
Date: Mon, 14 Nov 2011 01:02:32 +0100
Message-ID: <1321228952.3362.15.camel@fermat.scientia.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HBLg9lit2NnK8ge86ZhI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi.

Sorry for completely forgetting about this... (for so long)

I've tried your patch now against 3.1, and it seems to not help.

Not sure whether trying with 2.6.38 helps.
It "stopped" working within the very same kernel.

The old mainboard got broken and was replaced by a new one (of the same
type),... but perhaps the wifi controller is of a new revision or so?!


Cheers,
Chris.


On Thu, 2011-09-08 at 10:49 +0200, Stanislaw Gruszka wrote:
> On Mon, Sep 05, 2011 at 09:42:01AM +0000, Christoph Anton Mitterer wrote:
> > On Mon, 5 Sep 2011 11:19:18 +0200, Stanislaw Gruszka <sgruszka@redhat.c=
om>
> > wrote:
> > > this look like firmware hang. This happen just after module load, tha=
t's
> > > good news, because it allow to log relative small amount debug messag=
es
> > > to see what possibly driver do wrong to crash firmware.
> > Note, that the effects of - usually but not always - frozen system whil=
e
> > the errors are printed (sometimes keyboard input seems still be possibl=
e
> > during that) ... happen over and over again... say about every  10 minu=
tes
> > or so.
> > Not just the first time the modules is loaded.
> > Is the firmware loaded over and over again?
> I think is not, but even if is, kernel should not crash. Can you grab
> crash logs using photo camera, serial cable or netconsole, to allow to=
=20
> see where exactly crash happen and fix it.
>=20
> > > Please configure syslog to log kernel debug messages.
> > Will mail it later.
>=20
> Firmware hang seems to happen when REPLY_LEDS_CMD command is send.
> No idea if attached patch could help or not, but is worth to try it.
> It prevent to send LED command asynchronously, when possibly some
> other commands are pending in firmware.
>=20
> If it does not help, please provide the same way captured debug
> messages from 2.6.38 kernel, where drivers works. I'll compare
> it with broken driver logs to figure out what broken driver
> do differently.
>=20
> Thanks
> Stanislaw


--=-HBLg9lit2NnK8ge86ZhI
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIITMjCCBggw
ggPwoAMCAQICAQEwDQYJKoZIhvcNAQEEBQAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMV
aHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5
MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcwHhcNMDUxMDE0MDczNjU1WhcNMzMw
MzI4MDczNjU1WjBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5D
QWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290MIICIjANBgkqhkiG9w0BAQEF
AAOCAg8AMIICCgKCAgEAq0k1EUh80iZ+U5TPQ6ndKNdCKovzh3gZWHwPntqJfeH763KQDXShlmSr
n6AkmXPa4lV2xxd79QSsRrjDvn9kjRBsJPNhnMDykPpR5vVpAWPDD1biSkLP4kSMJSioxXkJfUa5
ivPp8zQpCEXkHJ/LlAQcgagUs5hlxEPsToKNCdG9qluNktDs3pDFfwrC4+vmMVpedD6XM1nowwM9
YDO/99FvR8TN7mKDUm4uCJqk2RUYkaaFkkewrkjrbbch7IUaaHI1q//wEF3A9JSnatU7kn5MkAV+
k8Esi6SOYnQVcW4LcQPqrxU4mtTSBXJvjPkr61pyJfk5RuNyGz4Ew2QnIhAqik9YpwOtvrQuE+1d
qkjX1X3UKntc+kYEUOTMDkJbjO3b8s/8lpPg2xE2VGI0OI8MYJs7l1Y4rfPSW4ugW+pOlrh819Wg
hnBA05Ept6I8rfWMu88akorkNHvA2Gxf6QrCw6cgmlrfLF1SXLpH1ZvvJChwOCAv1X8pwLJBA2iS
zOCczJdLRe86EAqrcDqYlXCtNbHqhSukHIAhMamuYHqAJkgAuAHAk2NVIpE8Vuev2zol848xVOom
i4FZ+aHRUxHFe50D9nQR4G2xLD8shpGZcZqmd4s0YNEUtCysna+MENOfxGr4bxP8c1n3ZkJ0Horj
+NzSb5icy0eYlUAF++kCAwEAAaOBvzCBvDAPBgNVHRMBAf8EBTADAQH/MF0GCCsGAQUFBwEBBFEw
TzAjBggrBgEFBQcwAYYXaHR0cDovL29jc3AuQ0FjZXJ0Lm9yZy8wKAYIKwYBBQUHMAKGHGh0dHA6
Ly93d3cuQ0FjZXJ0Lm9yZy9jYS5jcnQwSgYDVR0gBEMwQTA/BggrBgEEAYGQSjAzMDEGCCsGAQUF
BwIBFiVodHRwOi8vd3d3LkNBY2VydC5vcmcvaW5kZXgucGhwP2lkPTEwMA0GCSqGSIb3DQEBBAUA
A4ICAQB/CIih2hpQSdqJ+6EIcvOK9x7EOrR5WyAwsUXewl3TZWnxwl1UVDyFX7l7QpHCmf0bUZur
RqWhEFOebYisc24sM6bw9J7gdcE+iEWp4WZD/lZa0XpBePdA2ko68QtbpbsWBubC55O5hU2XT7Ee
OEOA75sNjO+4p2AAh1d9HkQcyyPvmzyZna+1KRxFeRaWTSdt8Rxsw8JVZLO8FOLzpB8eMvwnFQXP
3S6uPoJhe/AhEBj2ROpTOfnc0Jog4Ma74LtaT8SZyAe9tb2i2y5iDUI0Qbz/i4r1USKqiDAA4rDU
vL5lutUDV3mb6NzITfhQ7ZGlUiiirPs2WD7plCuRUIcb1l7WjMz3DxAMUk7QFmHl5QpsvxfHckZX
nJj1bGBjem9euU4vyLm5u2qFvJgN7fk+l4Q0lK4Ar6Hl55JuTr3z4tkUi1zS6wFsoBelLRDrnHpK
vb3uzv3tIkCrcDiI9QqHasKrBWDJSAXaU8HeRHdqs/M8PO2AvKY4SikkX/5ZO5slelZjAGS5XaRi
fVc2T62D7x+SU6COd1fd5WERPSMAkEw8+qNgkwSjrzX2DmqPT0pgp4UFbEahj/THduOhWVf3cbLE
bhRcbW1BZt8bk7HUAMPuy888PSGAqV9jZfzd4F+k9CvwhXFB1Gcl+xqxl67WmYITQdJupRuZJ4Dn
C6moADCCBo8wggR3oAMCAQICAwCyHTANBgkqhkiG9w0BAQUFADBUMRQwEgYDVQQKEwtDQWNlcnQg
SW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xh
c3MgMyBSb290MB4XDTEwMDgwMTIxMjc0M1oXDTEyMDczMTIxMjc0M1owggEdMSEwHwYDVQQDExhD
aHJpc3RvcGggQW50b24gTWl0dGVyZXIxJDAiBgkqhkiG9w0BCQEWFWNhbGVzdHlvQHNjaWVudGlh
Lm5ldDExMC8GCSqGSIb3DQEJARYibWFpbEBjaHJpc3RvcGguYW50b24ubWl0dGVyZXIubmFtZTEv
MC0GCSqGSIb3DQEJARYgY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyQGNlcm4uY2gxPjA8BgkqhkiG
9w0BCQEWL2NocmlzdG9waC5hbnRvbi5taXR0ZXJlckBwaHlzaWsudW5pLW11ZW5jaGVuLmRlMS4w
LAYJKoZIhvcNAQkBFh9jaHJpc3RvcGguYW50b24ubWl0dGVyZXJAbG11LmRlMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuwNa6CEzsTRd3bRYXPNn2KYKhFZbyPPk1CjuFfy+1PAfKBiG
JmhhHGkmwCdnOd5aVnGzwIPfTv/+Rw3Cuw2zJ4YmJmX3uNDz/l2M6h5MO7Bawv7CjdR+ljGaIBYi
gMuNaBawmoo60shkvOwf8df/Ou5KTxX7uL/hNOb1Q2/3yJWBBMPCbKD0nTvVH34nE1lfZxvKk/Mu
dT7jc/WZ3kJshsO7y0WS/DEDvqPiQI5zfCx/qslMYCSCwcqZ4/NHwEXX4zgt9tfPj34iBNLEod7H
zdNhCfdqn1j/FTsRI12M2OXEYhYgBoRNRYshPV10ePbV9+GPzvWlJm7Hn07fxVi4ZQIDAQABo4IB
nTCCAZkwDAYDVR0TAQH/BAIwADBWBglghkgBhvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRp
ZmljYXRlIGZvciBGUkVFIGhlYWQgb3ZlciB0byBodHRwOi8vd3d3LkNBY2VydC5vcmcwQAYDVR0l
BDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEEAYI3CgMDBglghkgBhvhC
BAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC5jYWNlcnQub3JnMIG6
BgNVHREEgbIwga+BFWNhbGVzdHlvQHNjaWVudGlhLm5ldIEibWFpbEBjaHJpc3RvcGguYW50b24u
bWl0dGVyZXIubmFtZYEgY2hyaXN0b3BoLmFudG9uLm1pdHRlcmVyQGNlcm4uY2iBL2NocmlzdG9w
aC5hbnRvbi5taXR0ZXJlckBwaHlzaWsudW5pLW11ZW5jaGVuLmRlgR9jaHJpc3RvcGguYW50b24u
bWl0dGVyZXJAbG11LmRlMA0GCSqGSIb3DQEBBQUAA4ICAQAQFRkG3/PZgFdEFzeQyB2Gy8aXvyfS
XpoF14+eAplacl6HXG874gfBw0VlTMkG7ynK3sh2cOEz20BMbly/MGT9tMpo246EhINlIwpfnqlS
GZ+AVXrmztX25Eler+fO2wOVEeCn+HV09wb95VJtdzeAVaWpON5cEjGm9TLpMfR3RDDDkkcKI1uB
kAcwVugRHmAXgx+2Mi6bDrG1q3TXA8JCdo+8ojdboSEpJvPXhXeKcN9N9ajLqcv/J0jp5s1jZCRn
oX8OGIu9KWYmD7w2dHaYDmi/JHAa1ddd38BjULi1azqAVr32f1UWzU12JucqGHvlsZvkr479f/jV
4G8ID7zz/KG0Qb1op7gOZnj56/ek2jHyFBlYnAsnqM2imqSkNZsOAhxLPsYvqE3APCTcFMSilCCD
66K8OLrzpAj6fzcY9UJ9pkRZBP+nkOTN9avqZivxwKR8Zvl4XG9NJEdftSDTjFaVeYjn8hiDW0c9
uqVlayI35d2L0jC6h/npeihVWSOBiqFd5sPepTrqe7AvPrpYR12QrbkYeqARcqYnLe3jKuyWyqhQ
EQty00Zb0n3d7ezZ15ECXBOQHhvlDkbT6UeGX3Xa9kvNYWIb62S1nZ4oicU94NPxwMYtttaOTjzY
3hb5/aS+TWT+xkTFSFmd2perZmiiyByCKC5bcp6cOPWgvzCCBo8wggR3oAMCAQICAwCyHTANBgkq
hkiG9w0BAQUFADBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5D
QWNlcnQub3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290MB4XDTEwMDgwMTIxMjc0M1oX
DTEyMDczMTIxMjc0M1owggEdMSEwHwYDVQQDExhDaHJpc3RvcGggQW50b24gTWl0dGVyZXIxJDAi
BgkqhkiG9w0BCQEWFWNhbGVzdHlvQHNjaWVudGlhLm5ldDExMC8GCSqGSIb3DQEJARYibWFpbEBj
aHJpc3RvcGguYW50b24ubWl0dGVyZXIubmFtZTEvMC0GCSqGSIb3DQEJARYgY2hyaXN0b3BoLmFu
dG9uLm1pdHRlcmVyQGNlcm4uY2gxPjA8BgkqhkiG9w0BCQEWL2NocmlzdG9waC5hbnRvbi5taXR0
ZXJlckBwaHlzaWsudW5pLW11ZW5jaGVuLmRlMS4wLAYJKoZIhvcNAQkBFh9jaHJpc3RvcGguYW50
b24ubWl0dGVyZXJAbG11LmRlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuwNa6CEz
sTRd3bRYXPNn2KYKhFZbyPPk1CjuFfy+1PAfKBiGJmhhHGkmwCdnOd5aVnGzwIPfTv/+Rw3Cuw2z
J4YmJmX3uNDz/l2M6h5MO7Bawv7CjdR+ljGaIBYigMuNaBawmoo60shkvOwf8df/Ou5KTxX7uL/h
NOb1Q2/3yJWBBMPCbKD0nTvVH34nE1lfZxvKk/MudT7jc/WZ3kJshsO7y0WS/DEDvqPiQI5zfCx/
qslMYCSCwcqZ4/NHwEXX4zgt9tfPj34iBNLEod7HzdNhCfdqn1j/FTsRI12M2OXEYhYgBoRNRYsh
PV10ePbV9+GPzvWlJm7Hn07fxVi4ZQIDAQABo4IBnTCCAZkwDAYDVR0TAQH/BAIwADBWBglghkgB
hvhCAQ0ESRZHVG8gZ2V0IHlvdXIgb3duIGNlcnRpZmljYXRlIGZvciBGUkVFIGhlYWQgb3ZlciB0
byBodHRwOi8vd3d3LkNBY2VydC5vcmcwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgor
BgEEAYI3CgMEBgorBgEEAYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUF
BzABhhZodHRwOi8vb2NzcC5jYWNlcnQub3JnMIG6BgNVHREEgbIwga+BFWNhbGVzdHlvQHNjaWVu
dGlhLm5ldIEibWFpbEBjaHJpc3RvcGguYW50b24ubWl0dGVyZXIubmFtZYEgY2hyaXN0b3BoLmFu
dG9uLm1pdHRlcmVyQGNlcm4uY2iBL2NocmlzdG9waC5hbnRvbi5taXR0ZXJlckBwaHlzaWsudW5p
LW11ZW5jaGVuLmRlgR9jaHJpc3RvcGguYW50b24ubWl0dGVyZXJAbG11LmRlMA0GCSqGSIb3DQEB
BQUAA4ICAQAQFRkG3/PZgFdEFzeQyB2Gy8aXvyfSXpoF14+eAplacl6HXG874gfBw0VlTMkG7ynK
3sh2cOEz20BMbly/MGT9tMpo246EhINlIwpfnqlSGZ+AVXrmztX25Eler+fO2wOVEeCn+HV09wb9
5VJtdzeAVaWpON5cEjGm9TLpMfR3RDDDkkcKI1uBkAcwVugRHmAXgx+2Mi6bDrG1q3TXA8JCdo+8
ojdboSEpJvPXhXeKcN9N9ajLqcv/J0jp5s1jZCRnoX8OGIu9KWYmD7w2dHaYDmi/JHAa1ddd38Bj
ULi1azqAVr32f1UWzU12JucqGHvlsZvkr479f/jV4G8ID7zz/KG0Qb1op7gOZnj56/ek2jHyFBlY
nAsnqM2imqSkNZsOAhxLPsYvqE3APCTcFMSilCCD66K8OLrzpAj6fzcY9UJ9pkRZBP+nkOTN9avq
ZivxwKR8Zvl4XG9NJEdftSDTjFaVeYjn8hiDW0c9uqVlayI35d2L0jC6h/npeihVWSOBiqFd5sPe
pTrqe7AvPrpYR12QrbkYeqARcqYnLe3jKuyWyqhQEQty00Zb0n3d7ezZ15ECXBOQHhvlDkbT6UeG
X3Xa9kvNYWIb62S1nZ4oicU94NPxwMYtttaOTjzY3hb5/aS+TWT+xkTFSFmd2perZmiiyByCKC5b
cp6cOPWgvzGCAr0wggK5AgEBMFswVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4xHjAcBgNVBAsTFWh0
dHA6Ly93d3cuQ0FjZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMgUm9vdAIDALIdMAkG
BSsOAwIaBQCgggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTEx
MTExNDAwMDIzMFowIwYJKoZIhvcNAQkEMRYEFKjimJOFkMqY1RBP6iVKfFaiT5zZMGoGCSsGAQQB
gjcQBDFdMFswVDEUMBIGA1UEChMLQ0FjZXJ0IEluYy4xHjAcBgNVBAsTFWh0dHA6Ly93d3cuQ0Fj
ZXJ0Lm9yZzEcMBoGA1UEAxMTQ0FjZXJ0IENsYXNzIDMgUm9vdAIDALIdMGwGCyqGSIb3DQEJEAIL
MV2gWzBUMRQwEgYDVQQKEwtDQWNlcnQgSW5jLjEeMBwGA1UECxMVaHR0cDovL3d3dy5DQWNlcnQu
b3JnMRwwGgYDVQQDExNDQWNlcnQgQ2xhc3MgMyBSb290AgMAsh0wDQYJKoZIhvcNAQEBBQAEggEA
BEA9iRzkCLMgKpNN5ivY4ishwTIC8lEAOUvdsVPL+bEC+y6rj0N+4Oqr9fflNiLsimVVQUSRygkm
wdYid1WU6/Ewxx/7rLRlZu6BlQ+ynYE9CvEdfjrhl7rBBu8riJHvNBx185yJnmCgTOSvldA/XHdr
jLhh+FCyiIEoGcWYdX20wj/1TLzsxyM4YrDEnn7Xc5q8cfF5VqMElISv/SlaQRXgXs2YScmHK7LW
r1hBUh5mCSqgtaemeYVLST3xbkWQJnrwpIPA7o0lbalOWTdJnxcmFSa2ytaCqV6ZkatAqLky0e4Q
RM3FFYPe4wSq4AgVh0n7K1pMzIHHNVnXhXsffQAAAAAAAA==


--=-HBLg9lit2NnK8ge86ZhI--

