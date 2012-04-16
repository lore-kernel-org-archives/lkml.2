Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2DPWZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:25:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43291 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DPWZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:25:50 -0400
MIME-Version: 1.0
In-Reply-To: <m2bomrz689.fsf@igel.home>
References: <1334016417-18748-1-git-send-email-ddaney.cavm@gmail.com>
 <20120411070332.6F3C03E081E@localhost> <m21unuoch5.fsf@igel.home>
 <CACxGe6sDcqu6TcS9ZYYeNffMdUrH0_SVou37H83qzM8mKAGV_A@mail.gmail.com> <m2bomrz689.fsf@igel.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 Apr 2012 16:25:29 -0600
X-Google-Sender-Auth: 7zBNTDV3YYWDl24ENTxVxpyDljo
Message-ID: <CACxGe6uBpO3AfGHLJQbDvapSm6_+h=gcRG2F1GwLPWe8L17KmA@mail.gmail.com>
Subject: Re: [PATCH] iqrdomain: Improve formatting in debugfs.
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 4:01 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Grant Likely <grant.likely@secretlab.ca> writes:
>
>> Also, gcc complains about it:
>>
>> /home/grant/hacking/linux/kernel/irq/irqdomain.c: In function ‘virq_debug_show’:
>> /home/grant/hacking/linux/kernel/irq/irqdomain.c:670:4: warning: '#'
>> flag used with ‘%p’ gnu_printf format [-Wformat]
>
> Then it's probably not such a good idea after all.

It would be a good idea if the warning can be suppressed.

g.
