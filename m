Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1FFFpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 01:45:00 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:6072 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab1FFFo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 01:44:59 -0400
Subject: Re: [PATCH] avr32:fix build error in at32ap700x.c
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1306941914-6262-1-git-send-email-wanlong.gao@gmail.com>
References: <1306941914-6262-1-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 06 Jun 2011 07:44:50 +0200
Message-ID: <1307339090.9413.2.camel@hcegtvedt.norway.atmel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jun 2011 05:44:54.0745 (UTC) FILETIME=[DCAD3C90:01CC240C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 23:25 +0800, Wanlong Gao wrote:
> The portnr is undeclared. This build error is introduced by commit
> 2b348e2f82f532e3aff8e0ce9293033b3294c1e0
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>

Thanks for the report and fix. I already have an identical patch in my
next branch [1], but I wanted to make sure I got all needed changes
before sending a pull request to merge upstream.

<snipp diff>

1: http://git.kernel.org/?p=linux/kernel/git/egtvedt/avr32-2.6.git;a=commit;h=6263e71e656a0e4442001fec7d887258a9cd6839

-- 
Hans-Christian Egtvedt

