Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0EKSc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:32:56 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38236 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0EKScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:32:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bRnSga8jjRoJ0Z12w5KoWaBzRCuzaObppsz9oEa7SkZPEcnxpl+3jlGULnpla3TE+P
         zVJXdv3wf1wc85mFpFQUbbDlAObau62SIej/xRnGfXWoq/6XRdX1Fr4sWB9jiRd2PS7G
         NanDtgkrD9ENFddL0g4QXvKnWoJvKhiBf4kk8=
Date: Tue, 11 May 2010 22:32:48 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] pda_power: add support for writeable properties
Message-ID: <20100511183248.GA2523@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <20100511174708.GA26777@oksana.dev.rtsoft.ru>
 <20100511175812.GH30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100511175812.GH30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 07:58:12PM +0200, Daniel Mack wrote:
[...]
> > Plus, that way you don't need is_writable().
> 
> Ugh, really? I would _much_ prefer to actually _see_ which property is
> writeable, just from looking at the file attributes in sysfs.

Well, yeah... that would be also good for userland apps (GUI
apps, in particular). Though, I'm not yet sure how to implement
it without modifying a global array...

To avoid the race that I described in previous email we could
insert some mutex, but I'd like to avoid the global stuff.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
