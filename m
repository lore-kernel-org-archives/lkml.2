Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab1FMKMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:12:15 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56573 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1FMKMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z/ONwuM9vXnVUju91dfbP+zD99AQ4lNvjeF2Pye15imeK/ffciPVCmazUut6qQbUiH
         aLgFGlkWDR4HrFoKRt03RAq8cNfF9xkGMn/9NFqKMm28SJi4tWFDEThlwXTtT5Xo9OfH
         GQ9TOhIFePCdXfaUmvZZkTGcGAdfG5FcobLg8=
Subject: Re: [PATCH] Documentation:change all arch/i386 to arch/x86 in
 Documentation
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        xiyoulinuxkernelgroup@googlegroups.com, linux-kernel@zh-kernel.org,
        rdunlap@xenotime.net
In-Reply-To: <20110613093138.GA4990@gmail.com>
References: <1307942898-3728-1-git-send-email-wanlong.gao@gmail.com>
	 <20110613093138.GA4990@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 18:11:52 +0800
Message-ID: <1307959912.2703.8.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 一, 2011-06-13 at 17:31 +0800, Harry Wei wrote:
> On Mon, Jun 13, 2011 at 01:28:18PM +0800, Wanlong Gao wrote:
> > From: Wanlong Gao <wanlong.gao@gmail.com>
> > 
> > Change all "arch/i386" to "arch/x86" in Documentaion/,
> > since the directory has changed.
> > 
> > Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> > ---
> Hi Wanlong,
> 	Thanks for your great work. But you have done many
> obsolete jobs. See following.
Hi harry:
Yes, I see, thanks for your suggestion, and I had fixed these and resend
this patch.

Thanks
Best regards
> >  4. Options
> >  ~~~~~~~~~~
> > -   Some options can be set in the source text (in arch/i386/boot/video.S).
> > +   Some options can be set in the source text (in arch/x86/boot/video.S).
> >  All of them are simple #define's -- change them to #undef's when you want to
> There is no arch/x86/boot/video.S file now. So your change has no 
> meaning. You should fix your patch again so that it is well for us.
> 
> NOTE: i just put an example file arch/x86/boot/video.S. Maybe there are
> still other obsolete files.
> 
> Thanks
> Harry Wei


