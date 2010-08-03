Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab0HCUbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:31:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57151 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab0HCUbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:31:34 -0400
Message-ID: <4C587C80.3040207@ti.com>
Date: Tue, 03 Aug 2010 15:30:56 -0500
From: Mike Turquette <mturquette@ti.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Power management minisummit at Linux Plumbers Conference
 (November	3-5)
References: <20100803182746.GA32276@srcf.ucam.org>
In-Reply-To: <20100803182746.GA32276@srcf.ucam.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> I'm planning on finalising the schedule for the power management 
> minisummit at the Linux Plumbers Conference by the end of this week. If 
> anyone has topics that they'd like to discuss (or be discussed, if you 
> can't make it) then please let me know or register at 
> http://www.linuxplumbersconf.org/2010/ocw/events/proposals/ and file a 

That link did not really work for me, but I think I found the right 
place after a few clicks.

> proposal there. We're likely to be concentrating on userspace/kernel 
> interaction rather than pure kernel topics, so if you've got anything to 
> say about how we can handle application requirements without 
> compromising on our power savings then we'd love to hear from you.

Just FYI, I proposed a discussion on the issues that create such a large 
power gap between a CPUIdle-only system and a system with suspend (with 
the assumption that the lowest C-state can be hit by both).

I don't really want to present a formal lecture on it, but it would be 
nice to discuss with the group what can be done to shrink that gap a 
little in kernel space (badly behaving timers in platform-independent 
code) and in userspace (power-aware timers, coalescing timers, etc).

This is not intended to be another suspend-blocker discussion, but more 
of a discussion on what it takes to get CPUIdle to be more effective.

Regards,
Mike
