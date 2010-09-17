Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0IQQGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:06:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55245 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab0IQQGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hfU8kCUutnRiVDqDCiUNRrrZLrut51m3kah0Ffkq/zJGhymqvpAqgTnMC0wKrHsXrn
         ZQ/WKbwQWoH2QXy3wFKXPE8MB6KHtn6KAzeanveYSqTL0qK+ZIXBg+DKiq0h4YiE9nP1
         B6XP/oF8eGfZ2CrW2oq05y6e1YEQdzGA7S+WQ=
Date: Fri, 17 Sep 2010 09:05:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uinput: add devname alias to allow module on-demand load
Message-ID: <20100917160554.GB14186@core.coreip.homeip.net>
References: <1282222699.1236.21.camel@yio.site>
 <AANLkTikpCt-RjK87qb0cwdu_uUSfR-Dn_0d5PYhETM5T@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikpCt-RjK87qb0cwdu_uUSfR-Dn_0d5PYhETM5T@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 11:53:43AM +0200, Kay Sievers wrote:
> On Thu, Aug 19, 2010 at 14:58, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: uinput: add devname alias to allow module on-demand load
> >
> > Recent modprobe and udev versions allow to create device nodes
> > for modules which are not loaded. Only the first access will cause
> > the in-kernel module loader to pull-in the module. Systems which
> > never access the device node will not needlessly load the module,
> > and no longer need init scripts or other facilities to unconditionally
> > load it.
> 
> Dmitry?
> 

[dtor@hammer work]$ git describe --contains 8905aaafb4b5d9764c5b4b54c7d03eb41bb0a7e9
v2.6.36-rc3~19^2~2

;)

-- 
Dmitry
