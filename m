Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0ETI5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 04:57:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:34189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab0ETI5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 04:57:36 -0400
Message-ID: <4BF4F979.4070903@kernel.org>
Date: Thu, 20 May 2010 10:57:29 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pierre Ossman <pierre-list@ossman.eu>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
References: <20100519225653.1fedb453@mjolnir.ossman.eu>	<20100519230426.47c6c1ed@mjolnir.ossman.eu>	<20100519232906.3be82279@mjolnir.ossman.eu>	<20100519233408.7436bd9b@mjolnir.ossman.eu> <20100520091429.192d560c@mjolnir.ossman.eu>
In-Reply-To: <20100520091429.192d560c@mjolnir.ossman.eu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 20 May 2010 08:57:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 09:14 AM, Pierre Ossman wrote:
> Note that this is a live system, so there is some chance that something
> wrote to than area, then restored it to the previous state. I'm not
> sure how likely that is.
> 
> If not, then it would seem that this is a problem in either the disks,
> the controller or the controller driver. The components are WD
> WD1002FAEX, sil3132 and sata_sil24 respectively.

There is a report that sil3124/32 recognizes FIS corruption but keeps
using the payload anyway thus leading to data corruption when the bus
condition on pci-e side isn't ideal.  Does moving the controller to
different slot make difference?

Thanks.

-- 
tejun
