Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1JURDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 13:03:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56688 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1JURDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 13:03:46 -0400
Date: Fri, 21 Oct 2011 19:03:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Tim Bird <tim.bird@am.sony.com>,
        Russell King <rmk@arm.linux.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: Add static kernel function stack size analyzer, for ARM
Message-ID: <20111021170339.GA22535@one.firstfloor.org>
References: <4E9E0B71.9020708@am.sony.com> <4E9E0C66.3020405@am.sony.com> <1861853.vLiqXrnQg4@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1861853.vLiqXrnQg4@wuerfel>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I thought we now had a gcc option for this. gcc documentation points to -Wstack-usage=XXX.
> This was first introduced on s390 in architecture specific gcc code, but should now work
> everywhere.

CONFIG_FRAME_WARN=...

Has been there forever for any architecture.

-Andi
