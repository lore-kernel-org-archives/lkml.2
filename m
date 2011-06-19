Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1FSVkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 17:40:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53535 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1FSVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 17:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=WjlO2czvlfKTwMN+cuTip1oYrJ1aYTqMnKSzEqvfxBL2sPpOoTvPGR3KQM17tto6xk
         aZzhj/yHR2AtWNm2KMz07AarQrRWjnJhKvE01slmPRohOQeAOckvGaZXF7zQs+DiFpXT
         d5by2XQVj3jlqUgJ1w0Uv41LT1u0zNTYFWmAA=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Date: Mon, 20 Jun 2011 07:36:29 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.39-ARCH; KDE/4.6.3; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <201104201358.50443.jasonbstubbs@gmail.com> <201105132044.25928.jasonbstubbs@gmail.com> <20110613235549.GA14762@kroah.com>
In-Reply-To: <20110613235549.GA14762@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106200736.29259.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011 09:55:49 Greg KH wrote:
> On Fri, May 13, 2011 at 08:44:25PM +1000, Jason Stubbs wrote:
> > As far as I can tell, the patches aren't applied to any trees yet and are
> > just sitting in .../gregkh/patches.git. If that's the case, what I would
> > like is for fix-samsung-brightness-min-max-calculations.patch to be
> > replaced with the version in https://lkml.org/lkml/2011/4/20/1 and I
> > resubmit a fixed (and enhanced)
> > add-support-for-samsung-nc210-nc110.patch that applies on top of it.
> > That way an enhancement patch won't hold up a bugfix patch should there
> > be any further issues.
> 
> Ok, I'll drop this one, but can you resend the above referenced patch so
> I can apply it?

Somehow I managed to screw things up again as the nc210-nc110 patch isn't
against the min-max-calculations patch... Doesn't matter though. The patch I
just resent applies on top of the nc210-nc110 patch that you already have in
patches.git.

> Sorry for the delay in working on this, my access to a samsung laptop is
> now gone, and I've been swamped with other stuff.

No problem.

> Any chance you want to take over maintaining this driver now yourself?
> You seem to have a much better understanding of it in places than I do
> at the moment, combined with a strong need to keep it working properly

I'm not exactly sure what that entails, but I don't have access to any specs
and have never dealt with any hardware programming before. Even these patches
don't directly deal with the hardware so I'm not sure that I'm best suited to
being the maintainer. Having said that, I'm happy to try my hand at any bugs
that arise and review any patches..

Regards,
Jason Stubbs
