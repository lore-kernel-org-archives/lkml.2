Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab0CWDxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 23:53:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41030 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0CWDxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 23:53:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dsEr9/GK6eaihfhwowGAHzqOPeRe5tKjwi34N63x5E+C8fBvJpTyH9pcbCpzNXcQ8b
         5ujaqsIjM5OXyqbN4SkA7R5q2ay01SbuZVQU3vtYDnKk4cOW0wPNUZjXjC1GfVBHlol3
         AN80ljORrShCtJN0ZGWuM2dWPPcaVIeAr6C3w=
Date: Mon, 22 Mar 2010 23:52:59 -0400
From: Vikram Dhillon <dhillonv10@gmail.com>
To: Richard Colquhoun <arfab@lavabit.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: fix spacing errors and commenting
 format in r8180_93cx6.c
Message-ID: <20100323035259.GB7228@ubuntu-devel>
References: <4B7C0406.9040400@lavabit.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <4B7C0406.9040400@lavabit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 17, 2010 at 02:58:14PM +0000, Richard Colquhoun wrote:
> From 764502ee11ccd601ee7fb6bc00e2333055b9dd41 Mon Sep 17 00:00:00 2001
> From: Richard Colquhoun <arfab28@valen.(none)>
> Date: Wed, 17 Feb 2010 12:32:13 +0000
> Subject: [PATCH] Staging: rtl8187se: fix spacing errors and commenting fo=
rmat in r8180_93cx6.c
>  This patch just fixes all of the errors highlighted by the checkpatch.pl=
 script
>  Signed-off-by: Richard Colquhoun <arfab@lavabit.com>
>=20
> ---
>  drivers/staging/rtl8187se/r8180_93cx6.c |   81 ++++++++++++++++---------=
------
>  1 files changed, 41 insertions(+), 40 deletions(-)
>=20
> diff --git a/drivers/staging/rtl8187se/r8180_93cx6.c b/drivers/staging/rt=
l8187se/r8180_93cx6.c
> index 7e4711f..51c59cb 100644
> --- a/drivers/staging/rtl8187se/r8180_93cx6.c
> +++ b/drivers/staging/rtl8187se/r8180_93cx6.c
> @@ -22,13 +22,13 @@
> =20
>  void eprom_cs(struct net_device *dev, short bit)
>  {
> -	if(bit)
> +	if (bit)
>  		write_nic_byte(dev, EPROM_CMD,
>  			       (1<<EPROM_CS_SHIFT) | \
> -			       read_nic_byte(dev, EPROM_CMD)); //enable EPROM
> +			       read_nic_byte(dev, EPROM_CMD)); #enable EPROM
>  	else
>  		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev, EPROM_CMD)\
> -			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
> +			       &~(1<<EPROM_CS_SHIFT)); #disable EPROM
> =20
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
> @@ -38,23 +38,23 @@ void eprom_cs(struct net_device *dev, short bit)
>  void eprom_ck_cycle(struct net_device *dev)
>  {
>  	write_nic_byte(dev, EPROM_CMD,
> -		       (1<<EPROM_CK_SHIFT) | read_nic_byte(dev,EPROM_CMD));
> +		       (1<<EPROM_CK_SHIFT) | read_nic_byte(dev, EPROM_CMD));
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
>  	write_nic_byte(dev, EPROM_CMD,
> -		       read_nic_byte(dev, EPROM_CMD) &~ (1<<EPROM_CK_SHIFT));
> +		       read_nic_byte(dev, EPROM_CMD)&~(1<<EPROM_CK_SHIFT));
>  	force_pci_posting(dev);
>  	udelay(EPROM_DELAY);
>  }
> =20
> =20
> -void eprom_w(struct net_device *dev,short bit)
> +void eprom_w(struct net_device *dev, short bit)
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
> @@ -66,11 +66,12 @@ short eprom_r(struct net_device *dev)
>  {
>  	short bit;
> =20
> -	bit=3D(read_nic_byte(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
> +	bit =3D (read_nic_byte(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
>  	udelay(EPROM_DELAY);
> =20
> -	if(bit) return 1;
> -	return 0;
> +	if (bit)
> +		return 1;
> +		return 0;
>  }
> =20
> =20
> @@ -78,7 +79,7 @@ void eprom_send_bits_string(struct net_device *dev, sho=
rt b[], int len)
>  {
>  	int i;
> =20
> -	for(i=3D0; i<len; i++){
> +	for (i =3D 0; i < len; i++) {
>  		eprom_w(dev, b[i]);
>  		eprom_ck_cycle(dev);
>  	}
> @@ -88,50 +89,50 @@ void eprom_send_bits_string(struct net_device *dev, s=
hort b[], int len)
>  u32 eprom_read(struct net_device *dev, u32 addr)
>  {
>  	struct r8180_priv *priv =3D ieee80211_priv(dev);
> -	short read_cmd[]=3D{1,1,0};
> +	short read_cmd[] =3D {1, 1, 0};
>  	short addr_str[8];
>  	int i;
>  	int addr_len;
>  	u32 ret;
> =20
> -	ret=3D0;
> -        //enable EPROM programming
> +	ret =3D 0;
> +	#enable EPROM programming
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
> +	} else{
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
>  	eprom_send_bits_string(dev, read_cmd, 3);
>  	eprom_send_bits_string(dev, addr_str, addr_len);
> =20
> -	//keep chip pin D to low state while reading.
> -	//I'm unsure if it is necessary, but anyway shouldn't hurt
> +	#keep chip pin D to low state while reading.
> +	#I'm unsure if it is necessary, but anyway shouldn't hurt
>  	eprom_w(dev, 0);
> =20
> -	for(i=3D0;i<16;i++){
> -		//eeprom needs a clk cycle between writing opcode&adr
> -		//and reading data. (eeprom outs a dummy 0)
> +	for (i =3D 0; i < 16; i++) {
> +		#eeprom needs a clk cycle between writing opcode&adr
> +		#and reading data. (eeprom outs a dummy 0)
>  		eprom_ck_cycle(dev);
>  		ret |=3D (eprom_r(dev)<<(15-i));
>  	}
> @@ -139,7 +140,7 @@ u32 eprom_read(struct net_device *dev, u32 addr)
>  	eprom_cs(dev, 0);
>  	eprom_ck_cycle(dev);
> =20
> -	//disable EPROM programming
> +	#disable EPROM programming
>  	write_nic_byte(dev, EPROM_CMD,
>  		       (EPROM_CMD_NORMAL<<EPROM_CMD_OPERATING_MODE_SHIFT));
>  	return ret;
> --=20
> 1.6.3.3

Looks good besides just one part and I guess that's just me may be: In some=
 cases where you put a # put a space between the # and the comment. Thanks.

Reviewed-by: Vikram Dhillon <opensolarisdev@gmail.com>
=20
--=20
Regards,
Vikram Dhillon

There is poetry and there is beauty in real sympathy; but there is more =E2=
=80=94 there is action. The noblest and most powerful form of sympathy is n=
ot merely the responsive tear, the echoed sigh, the answering look; it is t=
he embodiment of the sentiment in actual help.=20

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuoOxsACgkQcoBavQdRHcxLdwCfRtbcj+SWSbwB8TYLQH/eXZha
VekAoJMO47PUOxmLymzevE85FW0i7t1M
=uHN9
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
