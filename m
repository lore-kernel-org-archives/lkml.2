Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2HHF6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:58:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37565 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab2HHF6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:58:01 -0400
Date: Tue, 07 Aug 2012 22:58:00 -0700 (PDT)
Message-Id: <20120807.225800.1450928472652058111.davem@davemloft.net>
To: albcamus@gmail.com
Cc: chris@arachsys.com, mchan@broadcom.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] bnx2: update bnx2-mips-09 firmware to
 bnx2-mips-09-6.2.1b
From: David Miller <davem@davemloft.net>
In-Reply-To: <CANE52KgHpmR7qCUUf3ZiMeskCitcAiMzzdARzy3a4RpKb73_Gg@mail.gmail.com>
References: <20120713130405.GS13885@arachsys.com>
	<CANE52KgHpmR7qCUUf3ZiMeskCitcAiMzzdARzy3a4RpKb73_Gg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jike Song <albcamus@gmail.com>
Date: Wed, 8 Aug 2012 13:50:42 +0800

> On Fri, Jul 13, 2012 at 9:04 PM, Chris Webb <chris@arachsys.com> wrote:
>> Commit c2c20ef43d00 "bnx2: Update driver to use new mips firmware"
>> updated the bnx2 driver to use bnx2-mips-09-6.2.1b in place of
>> bnx2-mips-09-6.2.1a, but didn't replace the copy of bnx2-mips-09-6.2.1a
>> in firmware/bnx2/ with the new version.
>>
>> This means that the bnx2 driver stopped working altogether for users who
>> use CONFIG_FIRMWARE_IN_KERNEL to compile firmware together with drivers
>> into their kernel, rather than having a runtime firmware loader.
>>
> 
> Still not fixed in mainline? I encountered the same problem with
> v3.6-rc1-133-g42a579a.

The current firmware for all drivers are not distributed in the kernel
sources any longer, they are maintained in a completely seperate
repository.

The old ones are just kept around in the kernel sources for
compatability.

This is a FAQ.
