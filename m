Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1BGSgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:36:55 -0500
Received: from www.tglx.de ([62.245.132.106]:47812 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1BGSgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:36:54 -0500
Date: Mon, 7 Feb 2011 19:36:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@monstr.eu>
cc: linux-kernel@vger.kernel.org
Subject: Re: microblaze: Convert irq chip to new functions
In-Reply-To: <1297102176-20768-1-git-send-email-monstr@monstr.eu>
Message-ID: <alpine.LFD.2.00.1102071935440.31804@localhost6.localdomain6>
References: <1297102176-20768-1-git-send-email-monstr@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Michal Simek wrote:

> Hi Thomas,
> 
> I have tested them and there are several problems which I've fixed.
> I have added that changes to your patch 2/3. I am sending them as v2.
> 
> For all others patches:
> Tested-by: Michal Simek <monstr@monstr.eu>
> 
> They can go through your tree because you have all patches around irq.

They are not core code specific, so you can send them to linus in the
.39 merge window.

Thanks,

	tglx
