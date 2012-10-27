Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2J0Om6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 10:42:58 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:43395 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab2J0Om4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 10:42:56 -0400
Date: Sat, 27 Oct 2012 09:42:53 -0500
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH v4 1/5] zynq: use GIC device tree bindings
Message-ID: <20121027144253.GC5190@beefymiracle.amer.corp.natinst.com>
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200310.GB6713@beefymiracle.amer.corp.natinst.com>
 <0d1c4cf8-70d8-4d12-bd77-393009d32b22@CH1EHSMHS001.ehs.local>
 <20121027140053.GB5190@beefymiracle.amer.corp.natinst.com>
 <4fd22fac-49c4-4000-9e70-12e94f248753@AM1EHSMHS010.ehs.local>
MIME-Version: 1.0
In-Reply-To: <4fd22fac-49c4-4000-9e70-12e94f248753@AM1EHSMHS010.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/27/2012 09:42:45 AM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/27/2012 09:42:45 AM,
	Serialize complete at 10/27/2012 09:42:45 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32u276st3Jlj2kUU"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-27_04:2012-10-26,2012-10-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--32u276st3Jlj2kUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Oct 27, 2012 at 02:06:45PM +0000, Michal Simek wrote:
[...]
> I am not big fan to use dtsi solution because dts can be simple generated directly
> From Xilinx design tool based on your hw design. That's why I can't see any benefit
> To have dtsi file.

Can I ask you to reconsider?  We, for example, don't make any use of the
Xilinx dev tools to generate our device trees.  Having a dtsi allows for
easy extension of the zynq-7000 platform for our boards, without having
to carry duplicate data.

Is it going to be expected that users building kernels for their zynq
targets have access to the Xilinx EDK?

> > Would you like for me to pull this into v5, or spin up a separate patch series?
>
> Definitely not. I have checked patches but haven't got it work on the zc702.
> Not sure if you have run it on real hw or just on the qemu as you have mentioned
> In 5/5.

You're likely running into the issue Nick has identified in the thread
for patch 5 where the chosen virtual address for the uart doesn't seem
to work: http://www.spinics.net/lists/arm-kernel/msg203141.html

We haven't yet identified the root cause; any insight you can provide
here would be beneficial.

Otherwise, I'm considering reworking patch 5 to move the uart mapping to
a known working location.

Thanks,

   Josh

--32u276st3Jlj2kUU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQi/LtAAoJEEef0niEbw+lPXAQAIUKdc1+y2hlB0GQK/Pqb19E
vQhcKDOV0Wtl/98RtbPkjOTophyUEZtKwhkUfA9z4Hjc2vHNu+oZLWWBxzDD5hcf
TWcxvDvgEEx5SjUWK/7JxF20icys40qsxv1kxtaDyivFOz5zxJRUjdoOyruvK5ow
RFDtl2fgFpql0gj/e6oj77XwZdZUN0AlFnvvr2Ffp7IfqjkasoWT5qJh9Iu25ZCP
UaVCuNea4lHYoY1paurrORJ+rlaKJWa3mJ1NLB0Z/0QrweP2mjME70hqMc9u89Y7
rW2OBl8c6up4THV/XcpfwC+6sdrt/Yj+v1NxWqF39An2GiqmBfeoMQMkU4xARy11
RywEanweA45oGtUikAe+yQOyHL8Xd6y9aYbN1dUMLKg90PMSMbdDRDd+komukMZn
7QGRsga1EXuO/QOJY8gGgh5hMn4MoPgSe/PhMXONSPk93qPXhBDga02vvzcMyUOZ
C41zb2eDzL+LTKNCZ15q3KHwYvy+S63KFR0keEBV0mnsEciKDPssztW9PjROiesu
eRCYLShfYGJMZZEXLIJfma83AzeMq9YoV5mEB0oD1MBvCRX/wQgtUXqdrrObeKa4
9v7lt1372FyggMRW5bPNPzpa33ATfVSn56H7mdwDCjnQCUCLeAbTpOIsxwgy1mGI
S7TLu4Gkaewcdk+bJLWa
=cslO
-----END PGP SIGNATURE-----

--32u276st3Jlj2kUU--
