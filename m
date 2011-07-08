Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108Ab1GHJOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 05:14:41 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39864 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1GHJOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 05:14:40 -0400
Date: Fri, 8 Jul 2011 13:14:35 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Tommy Lin <tommy.lin.1101@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tommy Lin <tommy.lin@caviumnetworks.com>
Subject: Re: [PATCH 2/2] arch: arm: CNS3xxx select the correct CPU type
 CPU_V6K
Message-ID: <20110708091435.GB15142@oksana.dev.rtsoft.ru>
References: <1310104806-12984-1-git-send-email-tommy.lin@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1310104806-12984-1-git-send-email-tommy.lin@caviumnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 02:00:06PM +0800, Tommy Lin wrote:
> ARM11        -> CPU_V6
> ARM11 MPCore -> CPU_V6K
> CNS3xxx has ARM11 MPCore CPUs (dual core), but initially select the same single
> core CPU type. To select MPCore watchdog support, this patch correts the CPU
> type from CPU_V6 to CPU_V6K.
> 
> Signed-off-by: Tommy Lin <tommy.lin@caviumnetworks.com>
> ---

Imre Kaloz sent a similar patch yesterday:

http://www.spinics.net/lists/arm-kernel/msg131933.html

Which is now in the linux-cns3xxx.git tree.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
