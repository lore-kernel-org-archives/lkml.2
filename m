Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab0JZL3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 07:29:05 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:37724 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759794Ab0JZL3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 07:29:03 -0400
Message-ID: <4CC6BB80.5020801@opengridcomputing.com>
Date: Tue, 26 Oct 2010 06:29:04 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jiri Kosina <trivial@kernel.org>, Tom Tucker <tom@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] drivers/infiniband: Remove unnecessary KERN_<level>
 uses
References: <cover.1288059486.git.joe@perches.com> <a62c334347cbfbaf5c5acb29c2ae7acda84344a0.1288059486.git.joe@perches.com>
In-Reply-To: <a62c334347cbfbaf5c5acb29c2ae7acda84344a0.1288059486.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/25/2010 9:44 PM, Joe Perches wrote:
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   drivers/infiniband/hw/amso1100/c2_intr.c |    4 ++--
>   drivers/infiniband/hw/cxgb3/iwch_cm.c    |    4 ++--
>   drivers/infiniband/hw/cxgb4/cm.c         |    4 ++--
>   3 files changed, 6 insertions(+), 6 deletions(-)
>

Acked-by: Steve Wise <swise@opengridcomputing.com>

