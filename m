Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1DAM0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 08:26:43 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:51058 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753159Ab1DAM0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 08:26:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAAnDlU1Ld/sX/2dsb2JhbAAMhDzTGZEGgSiDTHcE
X-IronPort-AV: E=Sophos;i="4.63,282,1299474000"; 
   d="scan'208";a="102291151"
Message-ID: <4D95C47D.206@teksavvy.com>
Date: Fri, 01 Apr 2011 08:26:37 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Rob Landley <rlandley@parallels.com>,
        Pete Clements <clem@clem.clem-digital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net> <4D92C874.7040104@parallels.com> <4D931634.5030807@fusionio.com> <4D933584.5050005@parallels.com> <4D94432D.5080601@fusionio.com> <4D944544.9040705@parallels.com> <4D945247.4080404@fusionio.com> <4D945976.8000401@fusionio.com> <4D945BAD.10309@parallels.com> <4D9460F8.7080606@fusionio.com>
In-Reply-To: <4D9460F8.7080606@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-31 07:09 AM, Jens Axboe wrote:
..
> 
> Data point - only seems to happen on UP. If you add -smp X to kvm, then
> it boots and works just fine. It smells oddly like some sort of irq
> event.


Like perhaps an IRQ waiting on a spinlock that's held elsewhere ?
