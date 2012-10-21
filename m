Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2JUKjv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 06:39:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37825 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab2JUKju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 06:39:50 -0400
Date: Sun, 21 Oct 2012 12:39:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] Staging: winbond: wb35reg: Fixed coding style issues
Message-ID: <20121021103944.GD14031@elf.ucw.cz>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
 <1350059835-5408-6-git-send-email-mujeeb.adil@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350059835-5408-6-git-send-email-mujeeb.adil@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2012-10-12 22:07:11, Adil Mujeeb wrote:
> Fixed some of checkpatch.pl reported ERRORs and WARNING of similar types:
> 1. trailing statements should be on next line
> 2. no spaces at the start of a line
> 
> Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>

NAK. This makes it worse, not better. The code is simple enough. That
making it longer makes it unreadable.

									Pavel


>  void Wb35Reg_Update(struct hw_data *pHwData,  u16 RegisterNo,  u32 RegisterValue)
>  {
>  	struct wb35_reg *reg = &pHwData->reg;
>  	switch (RegisterNo) {
> -	case 0x3b0: reg->U1B0 = RegisterValue; break;
> -	case 0x3bc: reg->U1BC_LEDConfigure = RegisterValue; break;
> -	case 0x400: reg->D00_DmaControl = RegisterValue; break;
> -	case 0x800: reg->M00_MacControl = RegisterValue; break;
> -	case 0x804: reg->M04_MulticastAddress1 = RegisterValue; break;
> -	case 0x808: reg->M08_MulticastAddress2 = RegisterValue; break;
> -	case 0x824: reg->M24_MacControl = RegisterValue; break;
> -	case 0x828: reg->M28_MacControl = RegisterValue; break;
> -	case 0x82c: reg->M2C_MacControl = RegisterValue; break;
> -	case 0x838: reg->M38_MacControl = RegisterValue; break;
> -	case 0x840: reg->M40_MacControl = RegisterValue; break;
> -	case 0x844: reg->M44_MacControl = RegisterValue; break;
> -	case 0x848: reg->M48_MacControl = RegisterValue; break;
> -	case 0x84c: reg->M4C_MacStatus = RegisterValue; break;
> -	case 0x860: reg->M60_MacControl = RegisterValue; break;
> -	case 0x868: reg->M68_MacControl = RegisterValue; break;
> -	case 0x870: reg->M70_MacControl = RegisterValue; break;
> -	case 0x874: reg->M74_MacControl = RegisterValue; break;
> -	case 0x878: reg->M78_ERPInformation = RegisterValue; break;
> -	case 0x87C: reg->M7C_MacControl = RegisterValue; break;
> -	case 0x880: reg->M80_MacControl = RegisterValue; break;
> -	case 0x884: reg->M84_MacControl = RegisterValue; break;
> -	case 0x888: reg->M88_MacControl = RegisterValue; break;
> -	case 0x898: reg->M98_MacControl = RegisterValue; break;
> -	case 0x100c: reg->BB0C = RegisterValue; break;
> -	case 0x102c: reg->BB2C = RegisterValue; break;
> -	case 0x1030: reg->BB30 = RegisterValue; break;
> -	case 0x103c: reg->BB3C = RegisterValue; break;
> -	case 0x1048: reg->BB48 = RegisterValue; break;
> -	case 0x104c: reg->BB4C = RegisterValue; break;
> -	case 0x1050: reg->BB50 = RegisterValue; break;
> -	case 0x1054: reg->BB54 = RegisterValue; break;
> -	case 0x1058: reg->BB58 = RegisterValue; break;
> -	case 0x105c: reg->BB5C = RegisterValue; break;
> -	case 0x1060: reg->BB60 = RegisterValue; break;
> +	case 0x3b0:
> +		reg->U1B0 = RegisterValue;
> +		break;
> +	case 0x3bc:
> +		reg->U1BC_LEDConfigure = RegisterValue;
> +		break;
> +	case 0x400:
> +		reg->D00_DmaControl = RegisterValue;
> +		break;
> +	case 0x800:
> +		reg->M00_MacControl = RegisterValue;
> +		break;
> +	case 0x804:
> +		reg->M04_MulticastAddress1 = RegisterValue;
> +		break;
> +	case 0x808:
> +		reg->M08_MulticastAddress2 = RegisterValue;
> +		break;
> +	case 0x824:
> +		reg->M24_MacControl = RegisterValue;
> +		break;
> +	case 0x828:
> +		reg->M28_MacControl = RegisterValue;
> +		break;
> +	case 0x82c:
> +		reg->M2C_MacControl = RegisterValue;
> +		break;
> +	case 0x838:
> +		reg->M38_MacControl = RegisterValue;
> +		break;
> +	case 0x840:
> +		reg->M40_MacControl = RegisterValue;
> +		break;
> +	case 0x844:
> +		reg->M44_MacControl = RegisterValue;
> +		break;
> +	case 0x848:
> +		reg->M48_MacControl = RegisterValue;
> +		break;
> +	case 0x84c:
> +		reg->M4C_MacStatus = RegisterValue;
> +		break;
> +	case 0x860:
> +		reg->M60_MacControl = RegisterValue;
> +		break;
> +	case 0x868:
> +		reg->M68_MacControl = RegisterValue;
> +		break;
> +	case 0x870:
> +		reg->M70_MacControl = RegisterValue;
> +		break;
> +	case 0x874:
> +		reg->M74_MacControl = RegisterValue;
> +		break;
> +	case 0x878:
> +		reg->M78_ERPInformation = RegisterValue;
> +		break;
> +	case 0x87C:
> +		reg->M7C_MacControl = RegisterValue;
> +		break;
> +	case 0x880:
> +		reg->M80_MacControl = RegisterValue;
> +		break;
> +	case 0x884:
> +		reg->M84_MacControl = RegisterValue;
> +		break;
> +	case 0x888:
> +		reg->M88_MacControl = RegisterValue;
> +		break;
> +	case 0x898:
> +		reg->M98_MacControl = RegisterValue;
> +		break;
> +	case 0x100c:
> +		reg->BB0C = RegisterValue;
> +		break;
> +	case 0x102c:
> +		reg->BB2C = RegisterValue;
> +		break;
> +	case 0x1030:
> +		reg->BB30 = RegisterValue;
> +		break;
> +	case 0x103c:
> +		reg->BB3C = RegisterValue;
> +		break;
> +	case 0x1048:
> +		reg->BB48 = RegisterValue;
> +		break;
> +	case 0x104c:
> +		reg->BB4C = RegisterValue;
> +		break;
> +	case 0x1050:
> +		reg->BB50 = RegisterValue;
> +		break;
> +	case 0x1054:
> +		reg->BB54 = RegisterValue;
> +		break;
> +	case 0x1058:
> +		reg->BB58 = RegisterValue;
> +		break;
> +	case 0x105c:
> +		reg->BB5C = RegisterValue;
> +		break;
> +	case 0x1060:
> +		reg->BB60 = RegisterValue;
> +		break;
>  	}
>  }
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
