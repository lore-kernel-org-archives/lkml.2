Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1FYAyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 20:54:04 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42509 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1FYAyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 20:54:01 -0400
Date: Fri, 24 Jun 2011 17:51:29 -0700 (PDT)
Message-Id: <20110624.175129.1571051194021375640.davem@davemloft.net>
To: inaky.perez-gonzalez@intel.com
Cc: vitalivanov@gmail.com, johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alan-jenkins@tuffmail.co.uk,
        hmh@hmh.eng.br, linville@tuxdriver.com
Subject: Re: [PATCH] net: wimax: Remove of unused 'rfkill_input' pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <8F0C2E89B9AA20448D482EB589641EB3010264D9CC@orsmsx507.amr.corp.intel.com>
References: <1308766004.13761.32.camel@vivanov>
	<8F0C2E89B9AA20448D482EB589641EB3010264D9CC@orsmsx507.amr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Jun 2011 17:51:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Date: Wed, 22 Jun 2011 14:47:07 -0700

> On Wed, 2011-06-22 at 21:06 +0300, Vitaliy Ivanov wrote:
>> David,
>> 
>> Please apply.
>> 
>> I added here all the peoples who took part in
>> 19d337dff95cbf76edd3ad95c0cee2732c3e1ec5 commit for any comments.
>> 
>> Also performed all yes/no/mod config builds w/ no issues.
> 
>> >From b93ca8947e85e4ff7e9f314675d4770b90b77548 Mon Sep 17 00:00:00 2001
>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>> Date: Wed, 22 Jun 2011 20:57:49 +0300
>> Subject: [PATCH] net: wimax: Remove of unused 'rfkill_input' pointer
>> 
>> Seems like this was not cleaned during the 'rfkill: rewrite' checkin
>> 19d337dff95cbf76edd3ad95c0cee2732c3e1ec5.
>> 
>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
> 
> Acked-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>

Applied to net-next-2.6
