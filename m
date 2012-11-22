Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909Ab2KVUr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:47:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756512Ab2KVUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:47:23 -0500
Date: Thu, 22 Nov 2012 21:47:04 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com
Subject: Re: [PATCH v4 01/11] PWMSS: Add PWM Subsystem driver for
 parent<->child relationship
Message-ID: <20121122204704.GA16716@avionic-0098.adnet.avionic-design.de>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
 <1353503469-18634-2-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1353503469-18634-2-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:efcDxKB/Su72cTeqs12fr3J+Hg1/lRET7jMJzwhZVqy
 hL4T/b3WJboVIlpDG8fimtPUtphOs2xscVDs32JbSXFoc+w6v2
 Hfg/xKa+8Sr+tgJwPw1OA2oa28AgmWM1gd7vuUx/s1jFgdTTlD
 3P/PrSgNvDvPJzkJ4Lr1Oa45Z9WxnSa36G0+Vp75WW+Yi/sYDL
 T3xUNt0FWgeGOfNn1b8Y4Ju1S6UyXjZJoZSW57hCNh+zQHZOnO
 vvQ5fWIwhwYRgoxCus68jUZGQ7V2x4QUlZrlH/J1i0ovsMokWO
 IywPBWp9pQOqHaVM7f9BWrApAITkcXhs3bHAOm/PXXZMGwwFJG
 HBRcOUDwnubpAaFfjfABjanMGdNLMIB47/bIU8WFAbVTq/GyJi
 MGWUQFys2dZopk8npPH43rjl8itQbyq4J55y3+IXrGuXJbGLYL
 gKnGb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 21, 2012 at 06:40:58PM +0530, Philip, Avinash wrote:
[...]
> +static const struct of_device_id pwmss_of_match[] = {
> +	{
> +		.compatible	= "ti,am33xx-pwmss",
> +	},

For consistency with other drivers this should be all on one line.

> +static const struct dev_pm_ops pwmss_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(pwmss_suspend, pwmss_resume)
> +};

This could be even shorter:

static SIMPLE_DEV_PM_OPS(pwmss_pm_ops, pwmss_suspend, pwmss_resume);

Thierry

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQro9IAAoJEN0jrNd/PrOhYCAQAIcrU+FUhnK62NOazWRsB27c
vwcg05hwGy0qGCLP8fjkHCAR7bjvbuXTUAT9K7XsEP2bdvs3XfQrgX3LT6lGiTkO
8DwHgHmKmpUxPIclKx/8FFGyGP/lPO/Z1lvvim7q1LSb0B0Se59WkjMZVC3eH4CH
nEMVAKJSjFR51DceEiSMSVTJ/Lwd5hv9JR70SDEsfdDR2TV5Wai7X+2O8+Yt4dbl
FAi/7TDdzsaukmKncabuNkPhxJrwZXFKvXdzcYAmoK3SeSxneW1yzkhd62vVOPTO
DtlujllVm738iBeK5iSVt0Ec1/Jj4Gwe1nDHBcSHMLVu6vn2iKVB79i2RFmZTRVa
Id4U+/h1AuRJwmI13pE75RO+N7z1H3EgBWKrkN5ALDq2m0Bf9egzdQzQbwBbhqJs
59/3MwxYtxhDJ4GBQPDK9HA/uH0MZsnHy5q4mUk7Cza01tOPAhPpT7bCEFQ6wn/N
txipuErF9H8T0Q+HcALXE/eIo9DIX1LCQ+MHN0rDMPQ1U73Yrilkk8ZQIQOAGASn
IAnLHEePOJkvPWVbheaRVFKNHT27MA70EzmOdbP5wY4jx2fTSrBofFAk9bHzzc19
6LOtY1kua91Ct7XIMAjGQ3aRD2lskNxYkU8zFRZY0V5Cbxo8sGHSQMAbT1pN7jrc
ZUk3CkVlkrdSp++356xw
=k8vX
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
