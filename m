Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab0E0SoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:44:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50345 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0E0SoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:44:16 -0400
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org>
	<alpine.LFD.2.00.1005271915540.3032@localhost.localdomain>
	<20100527173118.GE2468@srcf.ucam.org>
	<1274981680.27810.5636.camel@twins>
	<20100527174019.GA3187@srcf.ucam.org>
	<20100527190515.08be091a@lxorguk.ukuu.org.uk>
	<20100527181533.GH3543@srcf.ucam.org>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 27 May 2010 11:44:13 -0700
In-Reply-To: <20100527181533.GH3543@srcf.ucam.org> (Matthew Garrett's message of "Thu\, 27 May 2010 19\:15\:33 +0100")
Message-ID: <87d3whi3r6.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Thu, May 27, 2010 at 07:05:15PM +0100, Alan Cox wrote:
>
>> I'd prefer we avoided mixing them up. Everyone seems fairly happy with
>> the current operator ordered suspend behaviour I believe ?
>
> No. The current mechanism can lose wakeup events.

And the proposed solution (suspend blockers) does nothing to solve the
loss of wakeup events during forced suspend.

Kevin
