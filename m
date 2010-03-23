Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0CWDuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:50:20 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:50930 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0CWDuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aBayNaKXKTHbjy2nyIoC9UDzOMjwqXm3jhnZh0lxXh1odkS3R/inufZmMPUwTeSbCq
         aYMTIiJk2gENV0QvGXpOoPQ3pEc6ceBHxdQGcM37c6HHa/aEq3gQMfzfE3dWdm9oLsvj
         h3SDQfvug/+S7xnl3NjXQs4e0w3JNowB9mMAs=
Date: Mon, 22 Mar 2010 23:49:59 -0400
From: Vikram Dhillon <dhillonv10@gmail.com>
To: Tim Schofield <tim@weberpafrica.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192e: fix spacing style issues in
 r8180_93cx6.c
Message-ID: <20100323034959.GA7228@ubuntu-devel>
References: <1265313429.29197.3.camel@aglovale>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1265313429.29197.3.camel@aglovale>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 04, 2010 at 07:57:09PM +0000, Tim Schofield wrote:
> >From ffe4ef649fc0bcd553d8901492a5385a42be585a Mon Sep 17 00:00:00 2001
> From: Tim Schofield <tim@weberpafrica.com>
> Date: Thu, 4 Feb 2010 18:28:48 +0000
> Subject: [PATCH] Staging: rtl8192e: fix spacing style issues in r8180_93c=
x6.c
>  This is a patch to the r8180_93cx6.c file that fixes up spacing issue wa=
rnings found by the checkpatch.pl tool
>  Signed-off-by: Tim Schofield <tim@weberpafrica.com>
>=20
> ---
>  drivers/staging/rtl8192e/r8180_93cx6.c |   63 ++++++++++++++++----------=
------
>  1 files changed, 32 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/staging/rtl8192e/r8180_93cx6.c b/drivers/staging/rtl=
8192e/r8180_93cx6.c
> index 79f7a0f..262ed5f 100644
> --- a/drivers/staging/rtl8192e/r8180_93cx6.c
> +++ b/drivers/staging/rtl8192e/r8180_93cx6.c
> @@ -22,7 +22,7 @@
> =20
>  static void eprom_cs(struct net_device *dev, short bit)
>  {
> -	if(bit)
> +	if (bit)
>  		write_nic_byte(dev, EPROM_CMD,
>  			       (1<<EPROM_CS_SHIFT) | \
>  			       read_nic_byte(dev, EPROM_CMD)); //enable EPROM
> @@ -38,23 +38,23 @@ static void eprom_cs(struct net_device *dev, short bi=
t)
>  static void eprom_ck_cycle(struct net_device *dev)
>  {
>  	write_nic_byte(dev, EPROM_CMD,
> -		       (1<<EPROM_CK_SHIFT) | read_nic_byte(dev,EPROM_CMD));
> +		       (1<<EPROM_CK_SHIFT) | read_nic_byte(dev, EPROM_CMD));
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
>  	write_nic_byte(dev, EPROM_CMD,
> -		       read_nic_byte(dev, EPROM_CMD) &~ (1<<EPROM_CK_SHIFT));
> +		       read_nic_byte(dev, EPROM_CMD) & ~(1<<EPROM_CK_SHIFT));
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
>  }
> =20
> =20
> -static void eprom_w(struct net_device *dev,short bit)
> +static void eprom_w(struct net_device *dev, short bit)
>  {
> -	if(bit)
> +	if (bit)
>  		write_nic_byte(dev, EPROM_CMD, (1<<EPROM_W_SHIFT) | \
> -			       read_nic_byte(dev,EPROM_CMD));
> +			       read_nic_byte(dev, EPROM_CMD));
>  	else
> -		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev,EPROM_CMD)\
> +		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev, EPROM_CMD)\
>  			       &~(1<<EPROM_W_SHIFT));
> =20
>  	force_pci_posting(dev);
> @@ -66,10 +66,11 @@ static short eprom_r(struct net_device *dev)
>  {
>  	short bit;
> =20
> -	bit=3D(read_nic_byte(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
> +	bit =3D (read_nic_byte(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
>  	udelay(EPROM_DELAY);
> =20
> -	if(bit) return 1;
> +	if (bit)
> +		return 1;
>  	return 0;
>  }
> =20
> @@ -78,7 +79,7 @@ static void eprom_send_bits_string(struct net_device *d=
ev, short b[], int len)
>  {
>  	int i;
> =20
> -	for(i=3D0; i<len; i++){
> +	for (i =3D 0; i < len; i++) {
>  		eprom_w(dev, b[i]);
>  		eprom_ck_cycle(dev);
>  	}
> @@ -88,37 +89,37 @@ static void eprom_send_bits_string(struct net_device =
*dev, short b[], int len)
>  u32 eprom_read(struct net_device *dev, u32 addr)
>  {
>  	struct r8192_priv *priv =3D ieee80211_priv(dev);
> -	short read_cmd[]=3D{1,1,0};
> +	short read_cmd[] =3D {1, 1, 0};
>  	short addr_str[8];
>  	int i;
>  	int addr_len;
>  	u32 ret;
> =20
> -	ret=3D0;
> +	ret =3D 0;
>          //enable EPROM programming
>  	write_nic_byte(dev, EPROM_CMD,
>  		       (EPROM_CMD_PROGRAM<<EPROM_CMD_OPERATING_MODE_SHIFT));
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
> =20
> -	if (priv->epromtype=3D=3DEPROM_93c56){
> -		addr_str[7]=3Daddr & 1;
> -		addr_str[6]=3Daddr & (1<<1);
> -		addr_str[5]=3Daddr & (1<<2);
> -		addr_str[4]=3Daddr & (1<<3);
> -		addr_str[3]=3Daddr & (1<<4);
> -		addr_str[2]=3Daddr & (1<<5);
> -		addr_str[1]=3Daddr & (1<<6);
> -		addr_str[0]=3Daddr & (1<<7);
> -		addr_len=3D8;
> -	}else{
> -		addr_str[5]=3Daddr & 1;
> -		addr_str[4]=3Daddr & (1<<1);
> -		addr_str[3]=3Daddr & (1<<2);
> -		addr_str[2]=3Daddr & (1<<3);
> -		addr_str[1]=3Daddr & (1<<4);
> -		addr_str[0]=3Daddr & (1<<5);
> -		addr_len=3D6;
> +	if (priv->epromtype =3D=3D EPROM_93c56) {
> +		addr_str[7] =3D addr & 1;
> +		addr_str[6] =3D addr & (1<<1);
> +		addr_str[5] =3D addr & (1<<2);
> +		addr_str[4] =3D addr & (1<<3);
> +		addr_str[3] =3D addr & (1<<4);
> +		addr_str[2] =3D addr & (1<<5);
> +		addr_str[1] =3D addr & (1<<6);
> +		addr_str[0] =3D addr & (1<<7);
> +		addr_len =3D 8;
> +	} else {
> +		addr_str[5] =3D addr & 1;
> +		addr_str[4] =3D addr & (1<<1);
> +		addr_str[3] =3D addr & (1<<2);
> +		addr_str[2] =3D addr & (1<<3);
> +		addr_str[1] =3D addr & (1<<4);
> +		addr_str[0] =3D addr & (1<<5);
> +		addr_len =3D 6;
>  	}
>  	eprom_cs(dev, 1);
>  	eprom_ck_cycle(dev);
> @@ -129,7 +130,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
>  	//I'm unsure if it is necessary, but anyway shouldn't hurt
>  	eprom_w(dev, 0);
> =20
> -	for(i=3D0;i<16;i++){
> +	for (i =3D 0; i < 16; i++) {
>  		//eeprom needs a clk cycle between writing opcode&adr
>  		//and reading data. (eeprom outs a dummy 0)
>  		eprom_ck_cycle(dev);
> --=20
> 1.6.3.3
>=20

Looks good :) nice work

Reviewed-by: Vikram Dhillon <opensolarisdev@gmail.com>
=09
--=20
Regards,
Vikram Dhillon

There is poetry and there is beauty in real sympathy; but there is more =E2=
=80=94 there is action. The noblest and most powerful form of sympathy is n=
ot merely the responsive tear, the echoed sigh, the answering look; it is t=
he embodiment of the sentiment in actual help.=20

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuoOmcACgkQcoBavQdRHcwAnwCeNzKs2UU40OX1lZXIP3KirjpX
0OAAoKLCXjeK8qXLWyM2tDP2v0416NBY
=3zrw
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
