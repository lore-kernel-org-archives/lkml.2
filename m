Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0CQMTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 08:19:04 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:62875 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab0CQMTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 08:19:01 -0400
Subject: Re: [PATCH v2] LEDS: fix race between LED device uevent and actual
 attributes creation
From: Richard Purdie <rpurdie@rpsys.net>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <201003170924.38919.ffainelli@freebox.fr>
References: <201003101832.18867.ffainelli@freebox.fr>
	 <201003170924.38919.ffainelli@freebox.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 12:18:45 +0000
Message-ID: <1268828325.3662.0.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 09:24 +0100, Florian Fainelli wrote:
> Richard,
> 
> Any thoughts?

Yes, I like the patch and its been queued in the LEDs tree and was
included in my last pull request to Linus.

Cheers,

Richard

