Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1GFLqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 07:46:36 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57698 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab1GFLqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 07:46:35 -0400
Date: Wed, 6 Jul 2011 15:46:30 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: tommy.lin@caviumnetworks.com
Cc: "'Tommy Lin'" <tommy.lin.1101@gmail.com>,
        "'Wim Van Sebroeck'" <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lin, Mac" <Mac.Lin@caviumnetworks.com>
Subject: Re: [PATCH 2/2] watchdog: mpcore_wdt Add reload value setting for
 CNS3xxx hardware
Message-ID: <20110706114629.GA32659@oksana.dev.rtsoft.ru>
References: <1309867548-7842-1-git-send-email-tommy.lin@caviumnetworks.com>
 <20110705140559.GA15771@oksana.dev.rtsoft.ru>
 <281B1F8BAB4D4BDABE7568809A0AEC1A@starsemi.com>
 <20110706111616.GA18967@oksana.dev.rtsoft.ru>
 <20110706112830.GA23184@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110706112830.GA23184@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 03:28:30PM +0400, Anton Vorontsov wrote:
> On Wed, Jul 06, 2011 at 03:16:16PM +0400, Anton Vorontsov wrote:
> > On Wed, Jul 06, 2011 at 06:05:37PM +0800, Tommy Lin wrote:
> > > Hi, I just found another patch that can solve the watchdog counter reload
> > > issue. Please ignore this patch, since it should not acceptable to use
> > > #ifdefs.
> > 
> > OK, great. Do I understand correctly that without Vitaly's patch,
> > your first patch is somewhat useless, as the watchdog will not work
> > or will work incorrectly? So should I postpone merging patch 1/2
> > until Vitaly's patch hit mainline?
> 
> Oh, I see that the issue isn't major, so I'll just merge the first
> patch.

Heh. Nope. It doesn't work without SMP:

warning: (ARCH_CNS3XXX) selects HAVE_ARM_TWD which has unmet direct dependencies (SMP)

And SMP support is not in the mainline, yet.

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
