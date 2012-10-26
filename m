Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab2JZNvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 09:51:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:9276 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab2JZNvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 09:51:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="asc'?scan'208";a="240552911"
Message-ID: <1351258892.1823.20.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: gpmi: remove unneccessary header
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Date: Fri, 26 Oct 2012 16:41:32 +0300
In-Reply-To: <1350147809-19616-1-git-send-email-shijie8@gmail.com>
References: <1350147809-19616-1-git-send-email-shijie8@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-bNa1PO206briqUKCWgu+"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bNa1PO206briqUKCWgu+
Content-Type: multipart/mixed; boundary="=-GEMvyQ16Ug5fEBj0iXLl"


--=-GEMvyQ16Ug5fEBj0iXLl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-10-13 at 13:03 -0400, Huang Shijie wrote:
> The whole gpmi-nand driver has turned to pure devicetree supported.
> So the linux/mtd/gpmi-nand.h is not neccessary now. Just remove it,
> and move some macros to the gpmi-nand driver itself.
>=20
> Signed-off-by: Huang Shijie <shijie8@gmail.com>

I cannot compile-test it because the MXS configuration file I always
used for compile-testing gpmi-nand patches (attached) does not work
anymore - I get the following compilation errors:

/home/dedekind/git/l2-mtd/arch/arm/include/asm/processor.h:82: warning: "__=
LINUX_ARM_ARCH__" is not defined
/home/dedekind/git/l2-mtd/arch/arm/include/asm/processor.h:97: warning: "__=
LINUX_ARM_ARCH__" is not defined
In file included from include/linux/time.h:6,
                 from include/uapi/linux/timex.h:56,
                 from include/linux/timex.h:56,
                 from include/linux/sched.h:17,
                 from arch/arm/kernel/asm-offsets.c:13:
include/linux/math64.h: In function 'div_u64_rem':
include/linux/math64.h:55: error: '__LINUX_ARM_ARCH__' undeclared (first us=
e in this function)
include/linux/math64.h:55: error: (Each undeclared identifier is reported o=
nly once
include/linux/math64.h:55: error: for each function it appears in.)
In file included from include/linux/mm_types.h:15,
                 from include/linux/sched.h:24,
                 from arch/arm/kernel/asm-offsets.c:13:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/page.h: At top level:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/page.h:107: error: #error Un=
known user operations model
In file included from include/linux/mm.h:44,
                 from arch/arm/kernel/asm-offsets.c:14:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/pgtable.h:210: warning: "__L=
INUX_ARM_ARCH__" is not defined
In file included from include/linux/scatterlist.h:10,
                 from include/linux/dma-mapping.h:9,
                 from arch/arm/kernel/asm-offsets.c:15:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/io.h:50: warning: "__LINUX_A=
RM_ARCH__" is not defined
In file included from include/linux/dma-mapping.h:76,
                 from arch/arm/kernel/asm-offsets.c:15:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/dma-mapping.h: In function '=
dma_mapping_error':
/home/dedekind/git/l2-mtd/arch/arm/include/asm/dma-mapping.h:94: error: imp=
licit declaration of function 'debug_dma_mapping_error'
In file included from /home/dedekind/git/l2-mtd/arch/arm/include/asm/cachef=
lush.h:15,
                 from arch/arm/kernel/asm-offsets.c:16:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/glue-cache.h: At top level:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/glue-cache.h:129: error: #er=
ror Unknown cache maintenance model
In file included from /home/dedekind/git/l2-mtd/arch/arm/include/asm/cachef=
lush.h:17,
                 from arch/arm/kernel/asm-offsets.c:16:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/cachetype.h:28: warning: "__=
LINUX_ARM_ARCH__" is not defined
/home/dedekind/git/l2-mtd/arch/arm/include/asm/cachetype.h:33: warning: "__=
LINUX_ARM_ARCH__" is not defined
In file included from arch/arm/kernel/asm-offsets.c:16:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/cacheflush.h:204: warning: "=
__LINUX_ARM_ARCH__" is not defined
/home/dedekind/git/l2-mtd/arch/arm/include/asm/cacheflush.h:206: warning: "=
__LINUX_ARM_ARCH__" is not defined
In file included from arch/arm/kernel/asm-offsets.c:17:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/glue-df.h:99: error: #error =
Unknown data abort handler type
In file included from arch/arm/kernel/asm-offsets.c:18:
/home/dedekind/git/l2-mtd/arch/arm/include/asm/glue-pf.h:54: error: #error =
Unknown prefetch abort handler type
make[1]: *** [arch/arm/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

--=20
Best Regards,
Artem Bityutskiy

--=-GEMvyQ16Ug5fEBj0iXLl
Content-Disposition: attachment; filename="arm-mxs_defconfig"
Content-Type: text/plain; name="arm-mxs_defconfig"; charset="UTF-8"
Content-Transfer-Encoding: base64

Q09ORklHX0VYUEVSSU1FTlRBTD15DQpDT05GSUdfU1lTVklQQz15DQpDT05GSUdfTk9fSFo9eQ0K
Q09ORklHX0hJR0hfUkVTX1RJTUVSUz15DQpDT05GSUdfSUtDT05GSUc9eQ0KQ09ORklHX0lLQ09O
RklHX1BST0M9eQ0KIyBDT05GSUdfVVRTX05TIGlzIG5vdCBzZXQNCiMgQ09ORklHX0lQQ19OUyBp
cyBub3Qgc2V0DQojIENPTkZJR19QSURfTlMgaXMgbm90IHNldA0KQ09ORklHX1BFUkZfRVZFTlRT
PXkNCiMgQ09ORklHX0NPTVBBVF9CUksgaXMgbm90IHNldA0KQ09ORklHX01PRFVMRVM9eQ0KQ09O
RklHX01PRFVMRV9GT1JDRV9MT0FEPXkNCkNPTkZJR19NT0RVTEVfVU5MT0FEPXkNCkNPTkZJR19N
T0RVTEVfRk9SQ0VfVU5MT0FEPXkNCkNPTkZJR19NT0RWRVJTSU9OUz15DQpDT05GSUdfQkxLX0RF
Vl9JTlRFR1JJVFk9eQ0KIyBDT05GSUdfSU9TQ0hFRF9ERUFETElORSBpcyBub3Qgc2V0DQojIENP
TkZJR19JT1NDSEVEX0NGUSBpcyBub3Qgc2V0DQpDT05GSUdfQVJDSF9NWFM9eQ0KQ09ORklHX1BS
RUVNUFRfVk9MVU5UQVJZPXkNCkNPTkZJR19BRUFCST15DQpDT05GSUdfREVGQVVMVF9NTUFQX01J
Tl9BRERSPTY1NTM2DQpDT05GSUdfQVVUT19aUkVMQUREUj15DQpDT05GSUdfRlBFX05XRlBFPXkN
CkNPTkZJR19ERVZUTVBGUz15DQojIENPTkZJR19GSVJNV0FSRV9JTl9LRVJORUwgaXMgbm90IHNl
dA0KQ09ORklHX01URD15DQpDT05GSUdfTVREX1RFU1RTPW0NCkNPTkZJR19NVERfUkVEQk9PVF9Q
QVJUUz15DQpDT05GSUdfTVREX1JFREJPT1RfUEFSVFNfUkVBRE9OTFk9eQ0KQ09ORklHX01URF9D
TURMSU5FX1BBUlRTPXkNCkNPTkZJR19NVERfQUZTX1BBUlRTPXkNCkNPTkZJR19NVERfQVI3X1BB
UlRTPW0NCkNPTkZJR19NVERfQ0hBUj15DQpDT05GSUdfTVREX0JMT0NLPW0NCkNPTkZJR19NVERf
QkxPQ0tfUk89eQ0KQ09ORklHX0ZUTD1tDQpDT05GSUdfTkZUTD15DQpDT05GSUdfTkZUTF9SVz15
DQpDT05GSUdfSU5GVEw9bQ0KQ09ORklHX1JGRF9GVEw9eQ0KQ09ORklHX1NTRkRDPXkNCkNPTkZJ
R19TTV9GVEw9eQ0KQ09ORklHX01URF9PT1BTPXkNCkNPTkZJR19NVERfU1dBUD15DQpDT05GSUdf
TVREX0NGST15DQpDT05GSUdfTVREX0pFREVDUFJPQkU9eQ0KQ09ORklHX01URF9DRklfQURWX09Q
VElPTlM9eQ0KQ09ORklHX01URF9DRklfSU5URUxFWFQ9bQ0KQ09ORklHX01URF9DRklfQU1EU1RE
PW0NCkNPTkZJR19NVERfQ0ZJX1NUQUE9eQ0KQ09ORklHX01URF9ST009bQ0KQ09ORklHX01URF9B
QlNFTlQ9eQ0KQ09ORklHX01URF9DT01QTEVYX01BUFBJTkdTPXkNCkNPTkZJR19NVERfUEhZU01B
UD1tDQpDT05GSUdfTVREX1BIWVNNQVBfQ09NUEFUPXkNCkNPTkZJR19NVERfSU1QQTc9bQ0KQ09O
RklHX01URF9HUElPX0FERFI9eQ0KQ09ORklHX01URF9QTEFUUkFNPXkNCkNPTkZJR19NVERfTEFU
Q0hfQUREUj15DQpDT05GSUdfTVREX0RBVEFGTEFTSD1tDQpDT05GSUdfTVREX0RBVEFGTEFTSF9P
VFA9eQ0KQ09ORklHX01URF9NMjVQODA9bQ0KIyBDT05GSUdfTTI1UFhYX1VTRV9GQVNUX1JFQUQg
aXMgbm90IHNldA0KQ09ORklHX01URF9TU1QyNUw9bQ0KQ09ORklHX01URF9TTFJBTT15DQpDT05G
SUdfTVREX1BIUkFNPXkNCkNPTkZJR19NVERfTVREUkFNPXkNCkNPTkZJR19NVERfQkxPQ0syTVRE
PXkNCkNPTkZJR19NVERfRE9DMjAwMD1tDQpDT05GSUdfTVREX0RPQzIwMDE9bQ0KQ09ORklHX01U
RF9ET0MyMDAxUExVUz1tDQpDT05GSUdfTVREX0RPQ0czPXkNCkNPTkZJR19NVERfTkFORF9FQ0Nf
U01DPXkNCkNPTkZJR19NVERfTkFORD15DQpDT05GSUdfTVREX05BTkRfRUNDX0JDSD15DQpDT05G
SUdfTVREX05BTkRfTVVTRVVNX0lEUz15DQpDT05GSUdfTVREX05BTkRfR1BJTz15DQpDT05GSUdf
TVREX05BTkRfRElTS09OQ0hJUD15DQpDT05GSUdfTVREX05BTkRfRElTS09OQ0hJUF9QUk9CRV9B
RFZBTkNFRD15DQpDT05GSUdfTVREX05BTkRfRElTS09OQ0hJUF9QUk9CRV9ISUdIPXkNCkNPTkZJ
R19NVERfTkFORF9ET0NHND15DQpDT05GSUdfTVREX05BTkRfTkFORFNJTT1tDQpDT05GSUdfTVRE
X05BTkRfUExBVEZPUk09eQ0KQ09ORklHX01URF9PTkVOQU5EPW0NCkNPTkZJR19NVERfT05FTkFO
RF9WRVJJRllfV1JJVEU9eQ0KQ09ORklHX01URF9PTkVOQU5EX0dFTkVSSUM9bQ0KQ09ORklHX01U
RF9PTkVOQU5EX09UUD15DQpDT05GSUdfTVREX09ORU5BTkRfU0lNPW0NCkNPTkZJR19NVERfTFBE
RFI9bQ0KQ09ORklHX01URF9VQkk9bQ0KQ09ORklHX01URF9VQklfR0xVRUJJPW0NCiMgQ09ORklH
X0JMS19ERVYgaXMgbm90IHNldA0KQ09ORklHX0FUTUVMX1BXTT15DQojIENPTkZJR19JTlBVVF9N
T1VTRURFVl9QU0FVWCBpcyBub3Qgc2V0DQojIENPTkZJR19JTlBVVF9LRVlCT0FSRCBpcyBub3Qg
c2V0DQojIENPTkZJR19JTlBVVF9NT1VTRSBpcyBub3Qgc2V0DQojIENPTkZJR19TRVJJTyBpcyBu
b3Qgc2V0DQojIENPTkZJR19MRUdBQ1lfUFRZUyBpcyBub3Qgc2V0DQojIENPTkZJR19ERVZLTUVN
IGlzIG5vdCBzZXQNCiMgQ09ORklHX0hXX1JBTkRPTSBpcyBub3Qgc2V0DQpDT05GSUdfSTJDPXkN
CkNPTkZJR19TUEk9eQ0KQ09ORklHX0RFQlVHX0dQSU89eQ0KQ09ORklHX0dQSU9fU1lTRlM9eQ0K
IyBDT05GSUdfSFdNT04gaXMgbm90IHNldA0KIyBDT05GSUdfVVNCX1NVUFBPUlQgaXMgbm90IHNl
dA0KQ09ORklHX0RNQURFVklDRVM9eQ0KIyBDT05GSUdfSU9NTVVfU1VQUE9SVCBpcyBub3Qgc2V0
DQojIENPTkZJR19ETk9USUZZIGlzIG5vdCBzZXQNCiMgQ09ORklHX0lOT1RJRllfVVNFUiBpcyBu
b3Qgc2V0DQpDT05GSUdfSkZGUzJfRlM9bQ0KIyBDT05GSUdfSkZGUzJfRlNfV1JJVEVCVUZGRVIg
aXMgbm90IHNldA0KQ09ORklHX0pGRlMyX1NVTU1BUlk9eQ0KQ09ORklHX0pGRlMyX0ZTX1hBVFRS
PXkNCkNPTkZJR19KRkZTMl9DT01QUkVTU0lPTl9PUFRJT05TPXkNCiMgQ09ORklHX0pGRlMyX1JU
SU1FIGlzIG5vdCBzZXQNCkNPTkZJR19KRkZTMl9SVUJJTj15DQpDT05GSUdfSkZGUzJfQ01PREVf
Tk9ORT15DQpDT05GSUdfVUJJRlNfRlM9bQ0KQ09ORklHX1VCSUZTX0ZTX0FEVkFOQ0VEX0NPTVBS
PXkNCiMgQ09ORklHX1VCSUZTX0ZTX0xaTyBpcyBub3Qgc2V0DQpDT05GSUdfTE9HRlM9eQ0KQ09O
RklHX1BSSU5US19USU1FPXkNCkNPTkZJR19GUkFNRV9XQVJOPTIwNDgNCkNPTkZJR19NQUdJQ19T
WVNSUT15DQpDT05GSUdfVU5VU0VEX1NZTUJPTFM9eQ0KQ09ORklHX0RFQlVHX0tFUk5FTD15DQpD
T05GSUdfTE9DS1VQX0RFVEVDVE9SPXkNCkNPTkZJR19USU1FUl9TVEFUUz15DQpDT05GSUdfUFJP
VkVfTE9DS0lORz15DQpDT05GSUdfREVCVUdfSU5GTz15DQpDT05GSUdfQkxLX0RFVl9JT19UUkFD
RT15DQpDT05GSUdfU1RSSUNUX0RFVk1FTT15DQpDT05GSUdfREVCVUdfVVNFUj15DQpDT05GSUdf
S0VZUz15DQpDT05GSUdfQ1JZUFRPPXkNCkNPTkZJR19DUllQVE9fQ1JDMzJDPW0NCiMgQ09ORklH
X0NSWVBUT19BTlNJX0NQUk5HIGlzIG5vdCBzZXQNCiMgQ09ORklHX0NSWVBUT19IVyBpcyBub3Qg
c2V0DQpDT05GSUdfQ1JDX0lUVV9UPW0NCkNPTkZJR19DUkM3PW0NCg==


--=-GEMvyQ16Ug5fEBj0iXLl--

--=-bNa1PO206briqUKCWgu+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQipMMAAoJECmIfjd9wqK03SUP/ifJXbraLELZRfds9rGO3n/4
Rl2hJePIrUXCt3ODfJBa6KAD/M81Ev8BuuaVzonys349c07tj7JE22hYOBR1HMjY
E+dLbR6RBhCeUwKgLjctVZzfYZSFz5vZk7UZKvAqLQKKPQRiBF76ONZDKEVzhgO8
o3VxD+JOsYR4opx+CTw4LVFYxgVzcMgPY3dCDUxeG6PfWxppDs3TFjNVj2OUnyMC
ZTFERzRFF45xzW24XxUFOYEZ3wai0o3+MOCoAbBsUgsBDN3U3h47wWAoEqs/lO1t
aCmvnAi5AJpLGWoABMHzgHmafHT0DgNw7Vtq3BeRuuhZC3CHEzDHdcLrQTP5n6Vt
7ye9Z0ZKXYdYV03yy9XWeQtrtwofntMPIM6gfHtbS+blFzvIIQWnYBsBUh/c0+LW
Hp3ZzTyElJoDVVFPVmHR9IcaSNOGMKxkd1t6ddkoSUoVFEtL++t8ynjRnxEAi+RK
WToUSPTbsf0WATJocWb4yNOY3eJoLeKivmsO260geDVJfdy67I+SEtZn6Q8vq7Jd
puo0WBWMtzBH4VmSix1SClV7/jCwlGsI7awvapSitWqN6cmgqc3NQy+Ao7O5xP0/
OGeC/5MezUCXeLikUHfKFYRS/2kCygM3kGIVSbODjXUfeFWaA1/U2AduiAfLAQG0
dYkCN5xoZThMTqwXUVR7
=Erdb
-----END PGP SIGNATURE-----

--=-bNa1PO206briqUKCWgu+--

