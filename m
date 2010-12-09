Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0LIBSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 20:18:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47222 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0LIBSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 20:18:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vCGUaV+TZjxyGMVFjizhS4kkUbdQezdnWQQcQBZ6/Ad2TeaQWXLi/YhU38i63Ddx9g
         6ZU5cHUFEhO8oIfj3e/8qQiHagsde219FAgjJiqrGGsWOAhmE/YmnESJZl4X7h6ovJ0K
         pJrCSw2wkhCcfr7dtdJDRQzGp4dVclE1VSh5Y=
Date: Wed, 8 Dec 2010 17:17:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Ping Cheng <pinglinux@gmail.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
Message-ID: <20101209011752.GH15294@core.coreip.homeip.net>
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
 <4CFFC3C2.1080905@canonical.com>
 <AANLkTikmomm2hd7AAJMTnY+=J2wPyVvodv2Ft0jFe7w2@mail.gmail.com>
 <20101208235805.GE15294@core.coreip.homeip.net>
 <4D002CE8.2060803@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D002CE8.2060803@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:12:08AM +0100, Henrik Rydberg wrote:
> >>>
> 
> >>> Is it assumed that the envelop has only two touches comprising it? Or is
> >>> it any number of touches? If it's any number of touches, how does one
> >>> know how many touches it is?
> >>
> >> Those are good questions. Specifying how many touches are in the
> >> envelop makes sense. It also covers rectangle as a special case of
> >> envelop.
> > 
> > I have a feeling that trying to accomodate non-rectangular, more than 2
> > point shapes without using native MT data is over-engineering the
> > problem... Do we have examples other than older generation Elantechs and
> > Synaptics that need envelope notion?
> > 
> 
> 
> Those are the ones targeted so far. Maybe appletouch could be added to the list
> as well. I imagine all drivers will end up using zero, one and two envelope points.

Even ones that fully support independent finger tracking?

-- 
Dmitry
