Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0KDLL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 07:11:57 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33199 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0KDLLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 07:11:55 -0400
Subject: Re: [PATCH] regulator: lock supply in regulator enable
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
In-Reply-To: <4CD28FA6.9030303@stericsson.com>
References: <4CD2847B.1060009@stericsson.com>
	 <1288865910.3277.23.camel@odin>  <4CD28FA6.9030303@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 11:11:52 +0000
Message-ID: <1288869112.3277.25.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-04 at 11:49 +0100, Mattias Wallin wrote:
> As I wrote, the problem that I had is solved with my previous patch.
> Right now I have no visible problem but I still think there is locks missing
> and would like your opinion on it.
> 
> /Wallin
> 
> On 11/04/2010 11:18 AM, Liam Girdwood wrote:
> > On Thu, 2010-11-04 at 11:01 +0100, Mattias Wallin wrote:
> >> This patch add locks around regulator supply enable.
> >>
> >> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> >> ---
> >> The previous patch I sent solves a problem seen in our system.
> >> This patch does not solve a problem I have seen but I still think
> >> it should be there. Or at least some locking of the supply in regulator enable.
> >> What do you guys think?
> > 
> > This sounds like guesswork. What exactly is the problem in your system ?
> > 

Sorry, got a busy schedule atm. Can you give us your reasoning behind
why you think we need a lock here ?

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

