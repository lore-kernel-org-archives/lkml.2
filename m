Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0CWPzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:55:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:4568 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab0CWPzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=V65auZGxlTFR6rF1bfvo+/rRijZvZB4ubgonb45Gdq1AaCrVRAhQaX9KKV3vI0q7Ew
         NMuolsJezvgjTRCgIylMgoFdmQ01mpG/RnOUpTsDqOkcgrTQjzEa9n1XqbLU4SNvy2W7
         HyCmnb6SnpLe4gnBQRGRupz6d8YFTxjtALDsg=
Date: Tue, 23 Mar 2010 18:54:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Vassilios Zafiropoulos <vasili3000@hotmail.com>
Cc: linux-kernel@vger.kernel.org, lydiawang@viatech.com.cn,
       alsa-devel@alsa-project.org
Subject: Re: broken microphone
Message-ID: <20100323155456.GA15084@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vassilios Zafiropoulos <vasili3000@hotmail.com>,
	linux-kernel@vger.kernel.org, lydiawang@viatech.com.cn,
	alsa-devel@alsa-project.org
References: <SNT110-W58162EDFB417DBBD0AE6C8C4270@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SNT110-W58162EDFB417DBBD0AE6C8C4270@phx.gbl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I added the Lydia Wang and the alsa people to the CC list.

regards,
dan carpenter

On Mon, Mar 22, 2010 at 10:55:06AM +0000, Vassilios Zafiropoulos wrote:
> 
> hello,
> 
> 
> 
>  this commit seems to break my microphone. please cc me, as i
> 
>  am not written on the mailing list. For any other info, please
> ask.
> 
> 
> 
>  yours,
> 
>  vasilis.
> 
> 
> 
>  --
> 
> 
> 
>  vasili@vaccone 
> 
>  /usr/src/linux-2.6 $ sudo git bisect bad
> 
> 
> 
>  f5271101faf1655d862849f42518c2a88ef394fb is the first bad commit
> 
>  commit 
> 
>  f5271101faf1655d862849f42518c2a88ef394fb
> 
>  Author: Lydia Wang 
> 
>  <lydiawang@viatech.com.cn>
> 
>  Date:   Sat Oct 10 19:07:35 2009 +0800
> 
> 
> 
>      
> 
>  ALSA HDA VIA: Add VIA_CTL_WIDGET_ANALOG_MUTE control type
> 
>      
> 
>      
> 
>  Enter low power state if AA-Path volume is muted.
> 
>      
> 
>      Signed-off-
> 
>  by: Lydia Wang <lydiawang@viatech.com.cn>
> 
>      Signed-off-by: Logan Li 
> 
>  <loganli@viatech.com.cn>
> 
>      Signed-off-by: Takashi Iwai <tiwai@suse.
> 
>  de>
> 
> 
> 
>  :040000 040000 ab1ae14ff67f0b08848faeb3ad68def7f3e727f0 
> 
>  0bfbfde11fe32e87e8edbdb3c4d03c2d30370393
> M      sound 		 	   		  
> _________________________________________________________________
> Hotmail: Free, trusted and rich email service.
> https://signup.live.com/signup.aspx?id=60969--
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
