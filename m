Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0CQM3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:29:35 -0400
Received: from zmc.proxad.net ([212.27.53.206]:54958 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab0CQM3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:29:34 -0400
X-Spam-Flag: NO
X-Spam-Score: -3.238
From: Florian Fainelli <ffainelli@freebox.fr>
Organization: Freebox
To: Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v2] LEDS: fix race between LED device uevent and actual attributes creation
Date: Wed, 17 Mar 2010 13:27:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-server; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201003101832.18867.ffainelli@freebox.fr> <201003170924.38919.ffainelli@freebox.fr> <1268828325.3662.0.camel@rex>
In-Reply-To: <1268828325.3662.0.camel@rex>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003171327.38516.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 March 2010 13:18:45 Richard Purdie wrote:
> On Wed, 2010-03-17 at 09:24 +0100, Florian Fainelli wrote:
> > Richard,
> >
> > Any thoughts?
> 
> Yes, I like the patch and its been queued in the LEDs tree and was
> included in my last pull request to Linus.

Ok, thanks. I actually did not see it in "[GIT PULL] led updates for 2.6.34-
rc2" that's why I asked.

Thanks.
