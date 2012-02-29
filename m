Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab2B2LkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:40:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:56638 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab2B2LkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:40:22 -0500
Message-ID: <4F4E0E9D.7090002@linutronix.de>
Date: Wed, 29 Feb 2012 12:40:13 +0100
From: Richard Weinberger <rw@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: tglx@linutronix.de, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
References: <1329250006-22944-1-git-send-email-rw@linutronix.de> <1330515322.3545.99.camel@sauron.fi.intel.com>
In-Reply-To: <1330515322.3545.99.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 29.02.2012 12:35, schrieb Artem Bityutskiy:
> On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
>> The following patch set implements checkpointing support for
>> UBI. Checkpointing is an optional feature which stores the physical to
>> logical eraseblock relations in a checkpointing superblock to reduce
>> the initialization time of UBI. The current init time of UBI is
>> proportional to the number of physical erase blocks on the FLASH
>> device. With checkpointing enabled the scan time is limited to a fixed
>> number of blocks.
> 
> Notice, your patch-set has huge amount of checkpatch.pl complaints -
> please fix them. This will also be consistent with the overall UBI
> coding style where I honored checkpatch.pl limitations like identation
> style and 80 chars per line.
> 

All checkpatch.pl complaints will be fixed.
But first we have to discuss and address real problems.

By sending the second iteration of the patch-set I'll make checkpatch.pl
happy. :-)

Thanks,
//richard

-- 
Phone: +49 7556 91 98 91; Fax.: +49 7556 91 98 86

Firmensitz: 88690 Uhldingen, Auf dem Berg 3
Registergericht: Amtsgericht Freiburg i. Br., HRB 700 806;
StNr. 87007/07777; Ust-Id Nr.: DE252739476
Geschäftsführer: Heinz Egger, Thomas Gleixner
