Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab0EJOSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:18:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38368 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0EJOSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:18:49 -0400
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Todd Fischer <todd.fischer@ridgerun.com>, linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 4/4]-V3 Add MFD driver for TPS6507x family of multi-function chips and move TPS6507x regulator driver from being stand-alone to using the MFD driver.
References: <1270520639-20516-1-git-send-email-todd.fischer@ridgerun.com>
	<1270520639-20516-2-git-send-email-todd.fischer@ridgerun.com>
	<1270520639-20516-3-git-send-email-todd.fischer@ridgerun.com>
	<1270520639-20516-4-git-send-email-todd.fischer@ridgerun.com>
	<1270520639-20516-5-git-send-email-todd.fischer@ridgerun.com>
	<87633kacmq.fsf@deeprootsystems.com>
	<20100509210940.GA3269@sortiz.org>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 10 May 2010 07:18:45 -0700
In-Reply-To: <20100509210940.GA3269@sortiz.org> (Samuel Ortiz's message of "Sun\, 9 May 2010 23\:09\:41 +0200")
Message-ID: <87tyqfq1q2.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Ortiz <sameo@linux.intel.com> writes:

> Hi Kevin,
>
> On Wed, Apr 21, 2010 at 11:23:09AM -0700, Kevin Hilman wrote:
>> Todd Fischer <todd.fischer@ridgerun.com> writes:
>> 
>> > Add MFD driver for TPS6507x family of multi-function chips.  Move TPS6507x 
>> > regulator driver from being stand-alone driver to using the MFD TPS6507x driver.
>> >
>> > Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>
>> 
>> [...]
>> 
>> Not sure whose tree this is queued in currently, but testing with
>> current davinci git, I had a compile problem...
>
> This is fixed in the MFD tree.
>

Thanks!

Kevin
