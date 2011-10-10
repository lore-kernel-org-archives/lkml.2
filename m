Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab1JJQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:29:16 -0400
Received: from unicorn.mansr.com ([78.86.181.103]:58640 "EHLO
	unicorn.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1JJQ3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:29:15 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Greg KH <gregkh@suse.de>
Cc: Harro Haan <hrhaan@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        Nicolas Pitre <nico@fluxnic.net>, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix ehci alignment error
References: <20111010124154.464239811@gmail.com>
	<20111010141402.GA21856@suse.de>
Date: Mon, 10 Oct 2011 17:29:13 +0100
In-Reply-To: <20111010141402.GA21856@suse.de> (Greg KH's message of "Mon, 10
	Oct 2011 07:14:02 -0700")
Message-ID: <yw1xipnwzu7a.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Mon, Oct 10, 2011 at 02:38:27PM +0200, Harro Haan wrote:
>> The Kirkwood gave an unaligned memory access error on
>> line 742 of drivers/usb/host/echi-hcd.c:
>> "ehci->last_periodic_enable = ktime_get_real();"
>
> What is "The Kirkwood"?  What size processor is this?

It's an ARM926-like CPU from Marvell.

-- 
Måns Rullgård
mans@mansr.com
