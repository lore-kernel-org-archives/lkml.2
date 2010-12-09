Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0LISsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:48:17 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:41373 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab0LISsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:48:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eomPuJx+rfnkQu+M5ntEjAa1ok/FBZP9siXSMfbJXeYxxkqx51kBrYGXDeEauyh6s1
         0pTaBG5UpvfrCSQ5zzjdnwEqofZCnKaKjoiwe/aGilajmJOgKsm/a5UiCz1xczRP7tyM
         +aSORLF0LbrgO0BSlCDuwJgIqhr6/uSD1AKyY=
Date: Thu, 9 Dec 2010 10:48:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] input: mt updates for 2.6.38
Message-ID: <20101209184807.GA23781@core.coreip.homeip.net>
References: <4CFF49BC.8030202@euromail.se>
 <20101209085814.GA8821@core.coreip.homeip.net>
 <20101209090826.GB8821@core.coreip.homeip.net>
 <4D011FA5.7000102@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D011FA5.7000102@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 07:27:49PM +0100, Henrik Rydberg wrote:
> > Input: include MT library as source for kerneldoc
> 
> > 
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > ---
> 
> 
> Looks good. Namewise, it means we stick to the current names for a bit, then?

I'd prefer moving to input/mt.h before input-mt.h started spreading
throughout the drivers. I could sit on the doc pluggin patch or you can
take it through you tree (adjusting as apporpriate).

-- 
Dmitry
