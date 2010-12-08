Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab0LHXys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:54:48 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:33565 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab0LHXyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Gw+ZVH2sEWdPaLV45vNQIkzfpfaQdAOtcDUwY2vijmi4iOL5VHOrMLMHIA3B77b1EU
         dPjFBzBs9E3Wtm0kYyaDizFjdtePHQpYcKFOuYL3GQIw69hObolADDjj67BB+YOPTBpq
         bQd7Bboa9DM1IbXQ652iY5l8LHEhz6Zn6yRk4=
Date: Wed, 8 Dec 2010 15:54:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ping Cheng <pingc@wacom.com>
Subject: Re: [PATCH] input: mt: Add hovering distance axis
Message-ID: <20101208235438.GD15294@core.coreip.homeip.net>
References: <1291710468-2022-1-git-send-email-rydberg@euromail.se>
 <4CFFC45C.2040107@canonical.com>
 <20101208180521.GA31522@core.coreip.homeip.net>
 <AANLkTinKVcc3KA3S_7-vwQWtDuUFZ2LSmjgrCrZXcRw5@mail.gmail.com>
 <4CFFD11D.4070107@euromail.se>
 <AANLkTinGhQC59jqdyJkVLs+mL9BydZp8gGi7c4XO_CL4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinGhQC59jqdyJkVLs+mL9BydZp8gGi7c4XO_CL4@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 03:31:12PM -0800, Ping Cheng wrote:
> On Wed, Dec 8, 2010 at 10:40 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > On 12/08/2010 07:20 PM, Ping Cheng wrote:
> >>
> >> ABS_DISTANCE is used in wacom driver as the distance between the tool
> >> tip and the tablet.
> >
> >
> > Thanks for the confirmation. While at it, what are the units for the distance,
> > for instance for the Cintiq?
> 
> mm? I am not so sure. It is a rough count of how far the tool is away
> from the tablet.

Count in what units? Millimeters, light years, pumpkins? ;)

-- 
Dmitry
