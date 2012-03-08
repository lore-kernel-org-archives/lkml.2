Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2CHJVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:21:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:40698 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2CHJVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 04:21:48 -0500
Message-ID: <4F587A28.6080205@linutronix.de>
Date: Thu, 08 Mar 2012 10:21:44 +0100
From: Richard Weinberger <rw@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
CC: dedekind1@gmail.com, tglx@linutronix.de, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
References: <1329250006-22944-1-git-send-email-rw@linutronix.de> <1331138007.3463.16.camel@sauron.fi.intel.com> <4F57D0C4.1050605@linutronix.de> <20120308090835.032fe13a@pixies.home.jungo.com>
In-Reply-To: <20120308090835.032fe13a@pixies.home.jungo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.03.2012 08:08, Shmulik Ladkani wrote:
> But doesn't the CP data (sorry, UBIUBI data :) need to have one
> 'struct ubi_cp_ec' descriptor for each used/free PEB, and as such the
> maximum number of 'ubi_cp_ec' descriptors is total device PEBs, meaning
> CP data is still linearly scaled to device size (with a very small
> multiplier)?
>

It's UBIVIS data. :D

The size of the checkpoint depends on the number of free/used PEBs.
But in most cases the checkpoints fits into one or two PEBs.
Because larger devices have larger erase blocks...

Thanks,
//richard

-- 
Phone: +49 7556 91 98 91; Fax.: +49 7556 91 98 86

Firmensitz: 88690 Uhldingen, Auf dem Berg 3
Registergericht: Amtsgericht Freiburg i. Br., HRB 700 806;
StNr. 87007/07777; Ust-Id Nr.: DE252739476
Geschäftsführer: Heinz Egger, Thomas Gleixner
