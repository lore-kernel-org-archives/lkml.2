Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0CVO3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:29:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51135 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0CVO3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=td3qWm4eBUo1TAIkmTfhZS8Bk5qxJV0Y+2wIIhrbhrA7EBvRJxoxf9M1c+NXOVnMmv
         S+KyIKEaJw04318QFNrptYGMUwX1XMAo0mI/uSjmfkLAJWZcT9lXOlhFP+d5XgbtEqFJ
         qsW2YZFRhLYwuvaTJ/hDyl+VeMkOGRKIBHjQ4=
Date: Mon, 22 Mar 2010 17:29:24 +0300
From: Dan Carpenter <error27@gmail.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: phy_calibration.c Coding style fixes
	1/2.
Message-ID: <20100322142924.GA23411@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Lars Lindley <lindley@coyote.org>, gregkh@suse.de, greg@kroah.com,
	penberg@cs.helsinki.fi, pavel@ucw.cz, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1269267447-6245-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269267447-6245-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 03:17:26PM +0100, Lars Lindley wrote:
> Whitespace and indentation fixes. Removed "commented away"
> code and revision comments.
> Checked with Dan Carpenters strip_whitespace.pl and diff.
> Compiles fine and .o file is identical before and after.
> 

	[ snip ]

> -#ifdef _DEBUG
> +	/* e. The result are shown in "adc_dc_cal_i[8:0] and adc_dc_cal_q[8:0]" */
> +	#ifdef _DEBUG
>  	hw_get_dxx_reg(phw_data, REG_OFFSET_READ, &val);
>  	PHY_DEBUG(("[CAL]    REG_OFFSET_READ = 0x%08X\n", val));
>  
>  	PHY_DEBUG(("[CAL]    ** adc_dc_cal_i = %d (0x%04X)\n",
> -			   _s9_to_s32(val&0x000001FF), val&0x000001FF));
> +			_s9_to_s32(val & 0x000001FF), val & 0x000001FF));
>  	PHY_DEBUG(("[CAL]    ** adc_dc_cal_q = %d (0x%04X)\n",
> -			   _s9_to_s32((val&0x0003FE00)>>9), (val&0x0003FE00)>>9));
> -#endif
> +			_s9_to_s32((val & 0x0003FE00) >> 9), (val & 0x0003FE00) >> 9));
> +	#endif
>  

#ifdef and #endif shouldn't be indented.

I'm really happy that you're using my script.  It feels more relaxing to 
review these when I know that no bugs were introduced.

regard,
dan carpenter
