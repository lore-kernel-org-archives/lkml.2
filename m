Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab2EGUwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:52:16 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:24237 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab2EGUwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:52:12 -0400
Message-ID: <4FA835FA.2090201@tilera.com>
Date: Mon, 7 May 2012 16:52:10 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 17/18] tile: Use common threadinfo allocator
References: <20120505150007.543515803@linutronix.de> <20120505150142.311126440@linutronix.de> <4FA54569.2040209@tilera.com> <alpine.LFD.2.02.1205072134130.6271@ionos> <4FA82A80.3090001@tilera.com> <alpine.LFD.2.02.1205072227540.6271@ionos>
In-Reply-To: <alpine.LFD.2.02.1205072227540.6271@ionos>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2012 4:33 PM, Thomas Gleixner wrote:
> On Mon, 7 May 2012, Chris Metcalf wrote:
>
>> I think the only obvious
>> way is to override something in the threadinfo allocator.
> Wrong. The obvious way is to use the common code and add a special
> flag to it.

Well, that's overriding something in the threadinfo allocator :-)

In all seriousness, adding an arch-specific GFP flag sounds like it should
work OK for tile.  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

