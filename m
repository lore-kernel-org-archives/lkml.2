Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2KEIol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:44:41 -0500
Received: from smtp.getmail.no ([84.208.15.66]:48115 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab2KEIok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:44:40 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Cc: linux-kernel@vger.kernel.org
In-reply-to: <1352080784-30839-2-git-send-email-luming.yu@gmail.com>
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
 <1352080784-30839-2-git-send-email-luming.yu@gmail.com>
Subject: Re: [PATCH 01/13] HW-latency: hardware latency test 0.10
To: Luming Yu <luming.yu@gmail.com>
Date: Mon, 05 Nov 2012 09:44:38 +0100
From: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
Message-id: <op.wnak8ogb1c32bs@localhost.localdomain>
User-Agent: Opera Mail/12.02 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012 02:59:32 +0100, Luming Yu <luming.yu@gmail.com> wrote:

> This patch is the first step to test some basic hardware functions like
> TSC to help people understand if there is any hardware latency as well
> as throughput problem exposed on bare metal or left behind by BIOS or
> interfered by SMI. Currently the patch tests TSC, CPU Frequency and
> RDRAND which is a new CPU instruction to get random number introduced in
> new CPU like Intel Ivy Bridge in stop_machine context,which is choosen to
> make sure testers fully control their system under test to rule out some
> level of unwanted noise.
>
> Signed-off-by: Luming Yu <luming.yu@intel.com>

That patch has my full stamp of approval!
