Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab0LSIUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 03:20:35 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49216 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0LSIUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 03:20:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L73TAZx3G/i4D2K03yqdiEoCkINwF64swDia8XjAYkFU5HS+I62blnHch6thSDS/qQ
         SArnBpBrnrQV5UhxyPIGX5E4UsKJ9kO20RXeEmKRogM1WTLb5/a8Mo8LQUHS0jfCvSbD
         OaTdh3/KmThcoJGTwVAahn7+ByA1iuLe+4M4g=
Date: Sun, 19 Dec 2010 00:20:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Andres Salomon <dilinger@queued.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, pgf@laptop.org,
        James Cameron <quozl@laptop.org>
Subject: Re: [PATCH] psmouse: disable the synaptics extension on OLPC
 machines.
Message-ID: <20101219082026.GD10074@core.coreip.homeip.net>
References: <20101217210939.19b6111a@queued.net>
 <20101218054927.GA14718@core.coreip.homeip.net>
 <20101217221447.375b9977@queued.net>
 <20101218070205.GA15847@core.coreip.homeip.net>
 <AANLkTimmcCB455DKt1jMVsLUTr5GdiUgFQzOWeiio361@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimmcCB455DKt1jMVsLUTr5GdiUgFQzOWeiio361@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 10:00:51AM +0000, Daniel Drake wrote:
> On 18 December 2010 07:02, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > What about just adding psmouse.proto=exps then?
> 
> It's not quite that simple either, because we want the same distro
> image to work on all versions of XO. XO's can come with either hgpk,
> synaptics, or sentelic touchpads. In the sentelic and hgpk cases, we'd
> want the "real" drivers to kick in.
> 

Hmm, I am confused. HGPK depends on OLPC so your distribution must have
it defined. Are there general purpose distributions that enable OLPC?

Thanks.

-- 
Dmitry
