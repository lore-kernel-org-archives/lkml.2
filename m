Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab1BTUv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 15:51:28 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:41901 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752793Ab1BTUv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:51:26 -0500
Message-ID: <4D617EF0.7020308@bluewatersys.com>
Date: Mon, 21 Feb 2011 09:52:00 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Charles Manning <manningc2@actrix.gen.nz>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <4D5DC368.2080003@bluewatersys.com> <20110218005852.GA14546@kroah.com> <201102210625.08616.manningc2@actrix.gen.nz> <20110220200755.GA26243@kroah.com>
In-Reply-To: <20110220200755.GA26243@kroah.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 09:07 AM, Greg KH wrote:
> On Mon, Feb 21, 2011 at 06:25:08AM +1300, Charles Manning wrote:
>> On Friday 18 February 2011 13:58:52 Greg KH wrote:
>> I still intend to keep the tracing printk-based tracing:
>>
>> #define yaffs_trace(msk, fmt, ...) do { \
>> 	if (yaffs_trace_mask & (msk)) \
>> 		printk(KERN_DEBUG "yaffs: " fmt "\n", ##__VA_ARGS__); \
>> } while (0)
> 
> No, please don't invent your own stuff like this, again, use the
> in-kernel functionality provided for this.

Do you mean using pr_debug? Other filesystems (see for example
fs/ubifs/debug.h:dbg_do_msg) and drivers have similar approaches to this
to allow printk debugging with multiple message levels.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
