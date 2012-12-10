Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2LJKa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:30:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab2LJKaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:30:55 -0500
Message-ID: <50C5B9D9.1080208@suse.cz>
Date: Mon, 10 Dec 2012 11:30:49 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Noam Camus <noamc@ezchip.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Makefile race between jobs
References: <264C179F799EF24AB26D5319053335E80CC3049A10@ezexch.ezchip.com> <50C4B8F3.6030704@suse.cz> <264C179F799EF24AB26D5319053335E80CC31B9D41@ezexch.ezchip.com> <20121210094515.GA31121@sepie.suse.cz> <50C5B54B.5080806@synopsys.com>
In-Reply-To: <50C5B54B.5080806@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.12.2012 11:11, Vineet Gupta wrote:
> ARC Port caches current task pointer in a register - thus we have a
> global asm register definition in current.h
> In the past, a customer ran into issue when porting some "really
> portable" code to kernel - such that asm/current.h didn't make it into
> the build of their module - via normal header includes - strange but
> true. Thus forcing current.h via way of -include seemed like a
> safe/sensible way.

To me that sounds like either an arc header is using the define but
lacking an include of asm/current.h, or the code is lacking asm/current.h.

Michal
