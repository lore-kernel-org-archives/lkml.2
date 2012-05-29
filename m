Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2E2JAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:00:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46831 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2E2JAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:00:00 -0400
Date: Tue, 29 May 2012 09:59:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: ALIM AKHTAR <alim.akhtar@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Re: [PATCH V2 0/1] dmaengine/amba-pl08x: Add support for
	s3c64xx DMAC
Message-ID: <20120529085939.GC12217@n2100.arm.linux.org.uk>
References: <0M4S00CB80QI0VX0@mailout3.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0M4S00CB80QI0VX0@mailout3.samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would you mind resending in a format which can actually be read please?

Thanks.

On Tue, May 29, 2012 at 08:54:18AM +0000, ALIM AKHTAR wrote:
> <html>
> <head>
> <meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />
> <title>Samsung Enterprise Portal mySingle</title>
> <style id="mysingle_style" type="text/css"> p, td, li {font-family:Arial, arial; font-size:9pt; margin-top:5px;margin-bottom:5px;} body{margin:10px 10px 10px 10px; line-height:1.4; font-family:Arial, arial; font-size:9pt;}
> </style>
> </head>
> <body>
> <p style="font-family: Arial; font-size: 10pt; ">Hi Russell</p>
> <p style="font-family: Arial; font-size: 10pt; ">Sorry, did not get time to rework on s3c pl080 dma patches.</p>
> <p><font class="Apple-style-span" face="Arial" size="2">I will&nbsp;re-base&nbsp;s3c pl080 patches on top of your virt-dma&nbsp;</font>changes<font class="Apple-style-span" face="Arial" size="2">.&nbsp;</font></p>
> <p><font class="Apple-style-span" face="Arial" size="2"><span class="Apple-style-span" style="line-height: 18px; "><br /></span></font></p>
> <p><font class="Apple-style-span" face="Arial" size="2"><span class="Apple-style-span" style="line-height: 18px; ">Regards,</span></font></p>
> <p><font class="Apple-style-span" face="Arial" size="2"><span class="Apple-style-span" style="line-height: 18px; ">Alim</span></font></p>
> <p style="font-family: Arial; font-size: 10pt; "><br /></p>
> <p style="font-family: Arial; font-size: 10pt; "><br /></p>
> <p style="font-family: Arial; font-size: 10pt; ">&nbsp;</p>
> <p style="font-family: Arial; font-size: 10pt; ">------- <b>Original Message</b> -------</p>
> <p style="font-family: Arial; font-size: 10pt; "><b>Sender</b> : Russell King - ARM Linux&lt;linux@arm.linux.org.uk&gt;</p>
> <p style="font-family: Arial; font-size: 10pt; "><b>Date</b>   : May 28, 2012 16:36 (GMT+09:00)</p>
> <p style="font-family: Arial; font-size: 10pt; "><b>Title</b>  : Re: [PATCH V2 0/1] dmaengine/amba-pl08x: Add support for s3c64xx	DMAC</p>
> <p style="font-family: Arial; font-size: 10pt; ">&nbsp;</p><font class="Apple-style-span" face="Arial" size="2">On Mon, May 28, 2012 at 12:41:42PM +0800, Linus Walleij wrote:</font><br />
> <font class="Apple-style-span" face="Arial" size="2">&gt; On Thu, Dec 8, 2011 at 9:03 AM, Alim Akhtar </font><alim.akhtar@gmail.com style="font-family: Arial; font-size: 10pt; "> wrote:<br />
> &gt; <br />
> &gt; &gt; Hello Linus,<br />
> &gt; &gt; sorry for the delay in submitting V3 of the pl080 patches for s3c64xx.<br />
> &gt; &gt; I am very busy with my current assignment.<br />
> &gt; &gt; I will come back to my patch series incorporating yours and Viresh<br />
> &gt; &gt; suggestions in v3.<br />
> &gt; <br />
> &gt; Ping on this, is there something in specific that you need help on here?<br />
> &gt; We really need to get rid of this forked code, and it should be beneficial<br />
> &gt; to S3C because we have fixed a lot of bugs in the PL08x driver now,<br />
> &gt; plus it'll likely be a prerequisite to DT support for S3C.<br />
> <br />
> So this hasn't gone in?<br />
> <br />
> This is going to be painful - I have 40 odd patches to PL08x converting it<br />
> to virt-dma now...&nbsp;&nbsp;It's probably going to be easier for the S3C conversion<br />
> to be based upon my work rather than me having to rework all those patches.<br />
> 
> <p>&nbsp;</p>
> <p>&nbsp;</p><!--SP:alim.akhtar--><!--alim.akhtar:EP-->
> <p>&nbsp;</p>
> <table id="confidentialsignimg">
> <tbody>
> <tr>
> <td namo_lock="namo_lock">
> <p><img src="cid:1CA8977932ED416E9D8527468A2126E80@samsung.net" width="520" border="0" alt="" /></p></td>
> </tr>
> </tbody>
> </table></alim.akhtar@gmail.com>
> </body>
> </html><img src='http://ext.samsung.net/mailcheck/SeenTimeChecker?do=6f840b097a85d5c50b4bac9baae6bbeca92d997207e98ce75f57f15697028f3f895240dbf1ac960d3bf06b239b6d34f6da4450058e9859eea728c55b39cc59eacf878f9a26ce15a0' border=0 width=0 height=0 style='display:none'>

