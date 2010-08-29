Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab0H2FsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 01:48:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60225 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0H2FsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 01:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XOpkJ865zivSnoChWsW0QAKfO4wUMNbEnkPhtSKq5iv+gMJ/WzRpEusaNwDjOLMTLu
         LmSjevnrxRdceXVbY2U8tlnQan5Ozke+oa1WuHxdvFJ6rop/ROBc2iR16FEOIFjBs4Sz
         NedwhRva/lv4CKkSIWuhljlmefgAFNeHzGa/M=
Date: Sat, 28 Aug 2010 22:48:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, pinglinux@gmail.com
Subject: Re: [PATCH v2] input: add multitouch slot support to w8001.
Message-ID: <20100829054805.GB15369@core.coreip.homeip.net>
References: <20100826020141.GA24887@barra.bne.redhat.com>
 <4C760CCA.4070403@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C760CCA.4070403@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 08:42:18AM +0200, Henrik Rydberg wrote:
> On 08/26/2010 04:01 AM, Peter Hutterer wrote:
> 
> > Some serial wacom devices support two-finger touch. Test for this during
> > init and parse the touch packets accordingly. Touch packets are
> > processed using Protocol B (MT Slots).
> >
> > Note: there are several wacom versions that do touch but not two-finger
> > touch. These are not catered for here, touch events for these are simply
> > discarded.
> >
> > Signed-off-by: Peter Hutterer <peter.hutterer@who-t.net>
> > CC: Henrik Rydberg <rydberg@euromail.se>
> > ---
> > Changes to v1:
> > - model MT slot approach after Henrik's bamboo patches
> > - add a comment about what the missing bytes are in the data packets
> >
> > Henrik, I think this addresses all your comments? The patch is certainly
> > a bit simpler now.
> 
> 
> Acked-by: Henrik Rydberg <rydberg@euromail.se>
> 
> Yes, thanks, it looks fine now. And thanks for finding the bug in my own
> version. :-)
> 

Applied all 3 to 'next', thanks Peter and Henrik.

-- 
Dmitry
