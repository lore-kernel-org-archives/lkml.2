Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0GLQIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:08:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60374 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0GLQIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:08:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MMSAKsKtWnHCVoJ/HXH5uzhj4s90WKKJqT/HN1ueyk/OoPHa2wDfoPy2g/C9AEUPQD
         Ac0Y5isNBGkBWC9mQhx3+fL2ThcnO8tq9KbrS+gu2JBviTm8//sbx4vFdwyYMvsSex9s
         +qJHDJkMErR4EsqMGru21oGQBoKqqlCQMry/A=
Date: Mon, 12 Jul 2010 09:07:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jerome Lacoste <jerome.lacoste@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active
 multiplexor, mouse won't work.)
Message-ID: <20100712160759.GA11964@core.coreip.homeip.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
 <20100701162454.GD4152@core.coreip.homeip.net>
 <AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
 <AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
 <20100701224235.GA29504@core.coreip.homeip.net>
 <AANLkTilPJ6Vod4zU4gfOC3id-Cxy_Ho4I5lxMh5fLaCV@mail.gmail.com>
 <20100703212015.GA32052@core.coreip.homeip.net>
 <AANLkTimYUdjdT4YAX4yHmJEDB0yeYmx3YGTMqQ7Pdp79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimYUdjdT4YAX4yHmJEDB0yeYmx3YGTMqQ7Pdp79@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 04:28:41PM +0200, Jerome Lacoste wrote:
> On Sat, Jul 3, 2010 at 11:20 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> [...]
> >> > Could you please also try i8042.reset instead of i8042.nomux?
> >>
> >> the i8042.reset works so far after 5 resumes.
> >>
> >> Tested with: Linux expresso2 2.6.32-23-generic #37-Ubuntu SMP Fri Jun
> >> 11 07:54:58 UTC 2010 i686 GNU/Linux
> >>
> >> Should I test something else ?
> >>
> >
> > Coudl you please try the patch below?
> >
> > Thanks.
> 
> Patch works ( I adapted it to work for my kernel:
> http://launchpadlibrarian.net/51784930/0001-Input-i8042-reset-keyboard-controller-wehen-resuming.patch
> )
> 
> Sorry it took me quite a bit of time to manage to get Ubuntu's git
> repo cloned and build my kernel.
> 
> I suspended/resumed 3 times so far after removing the i8042.quiet
> option. There's nothing wrong in the logs. I'll report if I see a
> problem.
> 
> I haven't noticed delays in resuming.
> 

Great, I will mark it as 'Tested-by:' by you then.

-- 
Dmitry
