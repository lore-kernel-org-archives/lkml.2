Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1CANsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 08:48:32 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:52039 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753781Ab1CANsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 08:48:31 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAGaHbE1Ld/sX/2dsb2JhbAAMhBzNJ5ElgSeDRHYEhRI
X-IronPort-AV: E=Sophos;i="4.62,246,1297054800"; 
   d="scan'208";a="93923058"
Message-ID: <4D6CF92A.4020105@teksavvy.com>
Date: Tue, 01 Mar 2011 08:48:26 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Krzysztof Halasa <khc@pm.waw.pl>, linux-ide@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: NEC ND-4550A problems reading DVD-R
References: <m339n7g7tw.fsf@intrepid.localdomain> <20110301080153.GA26074@htj.dyndns.org>
In-Reply-To: <20110301080153.GA26074@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-01 03:01 AM, Tejun Heo wrote:
..
> I think that's determined by drivers/scsi/sr.h::SR_TIMEOUT which is
> hardcoded to be 30 seconds.  Maybe it's better to move it to use the
> block parameter.  Anyways, the drive actually takes longer than 30secs
> to recognize the media?

That slow behaviour is not uncommon, especially as drives struggle
to recognize various forms of copy-protected media (DVD-Video).
A longer default, or tuneable timeout, would help.

Cheers

