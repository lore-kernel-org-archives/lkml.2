Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1HHQjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:39:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41523 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1HHQjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:39:41 -0400
Subject: Re: [PATCH 0/4] regulator: tps65023: patch updates
From: Liam Girdwood <lrg@kernel.org>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
	 <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:39:36 +0100
Message-ID: <1312821576.3316.2.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 13:33 +0200, Marcus Folkesson wrote:
> I'm currently fighting with my email-client (Mark, sorry for the draft just sent), but this should be proper in both formatting and email-list.
> 
> 
> Changes from previous patches:
>  * Split up [PATCH 1/3] into two seperate patches ([PATCH [1-2]/4])
>  * Declared tps_driver_data.info as const for avoiding awkward typecastings
>  * Removed table-length structs and uses tps->table_len instead. (As Axel Lin suggested in lkml)
> 

I've applied patch 1. 3 & 4 don't apply against -next.

Can you resend and add Mark's Acks to the relevant patches.

Thanks

Liam

