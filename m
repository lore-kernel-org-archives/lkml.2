Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0EZHni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:43:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35414
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377Ab0EZHnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:43:37 -0400
Date: Wed, 26 May 2010 00:43:47 -0700 (PDT)
Message-Id: <20100526.004347.115926528.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: error27@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] kobject: free memory if netlink_kernel_create() fails
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1d3wk2s7y.fsf@fess.ebiederm.org>
References: <20100525095110.GG22515@bicker>
	<m1d3wk2s7y.fsf@fess.ebiederm.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 25 May 2010 03:25:37 -0700

> Dan Carpenter <error27@gmail.com> writes:
> 
>> There is a kfree(ue_sk) missing on the error path if 
>> netlink_kernel_create() fails.
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

Greg, I assume you've got this one?

Thanks!
