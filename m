Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab0FIMHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:07:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59429 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab0FIMHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:07:08 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Yedire\, Sandeep" <syedire@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Ext2/3 Filesystem Analysis
From: Andi Kleen <andi@firstfloor.org>
References: <AANLkTinfPl-JAP_4ZzdzJf2uyWcZ_0qfRQiT16_D8Pdd@mail.gmail.com>
	<20100609105802.62d2ddce@lxorguk.ukuu.org.uk>
Date: Wed, 09 Jun 2010 14:06:55 +0200
In-Reply-To: <20100609105802.62d2ddce@lxorguk.ukuu.org.uk> (Alan Cox's message of "Wed\, 9 Jun 2010 10\:58\:02 +0100")
Message-ID: <87wru84dgg.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> With Ext3:
>> Filesystem block at Sector 0 is being updated more frequently at ratio
>> of 5.5 to 6 times that of data block.
>> Filesystem block(super block copies) are being updated at around
>> 1.5times the frequency compared to data block.
>> 
>> Has anyone come across this kind of behaviour with these filesystems
>> on NAND Flash?
>
> ext2/3 are not intended to be used with flash - they do not wear level,

Or rather not intended to be used with flash that does not have
an own wear level layer.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
