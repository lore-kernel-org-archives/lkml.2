Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0GNW2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:28:49 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21997 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0GNW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:28:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6043"; a="47348880"
From: David Brown <davidb@codeaurora.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH 10/11] staging: msm: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 15:28:42 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.1; KDE/4.4.5; x86_64; ; )
Cc: kernel-janitors@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Daniel Walker <dwalker@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1279130759-17608-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1279130759-17608-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007141528.43290.davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 July 2010 11:05:58 Kulikov Vasiliy wrote:

> Use %p instead of %08x in printk().
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Acked-by: David Brown <davidb@codeaurora.org>
