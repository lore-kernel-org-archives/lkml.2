Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab0L2HoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 02:44:18 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48547 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0L2HoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 02:44:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YgbEm0qdjfgyqlHLPkXSm5xYgb118EInCz3fy2L0sfCTQEiybO3Yg7ejVQxqyHfzNX
         teZxpkwZSGVzxqOzqpZZ98G9bHXfo2PA1ESk9iFERxT8CbEqiHzlfGldiiqYFujnV0wi
         1/FszOqXvDSKnh/tXG1M8IPHuIHQK8MGktWZQ=
Date: Tue, 28 Dec 2010 23:44:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Synaptics touchpad on Dell Vostro V13
Message-ID: <20101229074410.GC13061@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1012141547570.15140@pobox.suse.cz>
 <20101214170027.GA11318@core.coreip.homeip.net>
 <alpine.LNX.2.00.1012152348440.16569@pobox.suse.cz>
 <201012151523.09476.dmitry.torokhov@gmail.com>
 <alpine.LNX.2.00.1012281124030.16569@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012281124030.16569@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 11:28:48AM +0100, Jiri Kosina wrote:
> On Wed, 15 Dec 2010, Dmitry Torokhov wrote:
> 
> > 
> > Hmm, and what happens if you force dfl = 0 in i8042_interrupt()? It looks
> > like controller FW screwed up...
> 
> Yeah, that makes the thing work correctly (together with nomux). This all 
> is really strange, isn't it? I doubt other OS discards I8042_STR_TIMEOUT 
> completely :)
> 

Looking at the latest bugzilla comment for this laptop it appears
exactly what custome Dell drivers do ;)

Well, another blacklist in i8042 I guess...

-- 
Dmitry
