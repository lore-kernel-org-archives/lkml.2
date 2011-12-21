Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1LUUcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:32:05 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54997 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1LUUcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:32:03 -0500
Date: Wed, 21 Dec 2011 15:31:52 -0500 (EST)
Message-Id: <20111221.153152.331142885585888750.davem@davemloft.net>
To: matt@console-pimps.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, oleg@redhat.com,
        matt.fleming@intel.com, sparclinux@vger.kernel.org
Subject: Re: [PATCH 1/2] sparc: Make SA_NOMASK a synonym of SA_NODEFER
From: David Miller <davem@davemloft.net>
In-Reply-To: <1324493221-4435-2-git-send-email-matt@console-pimps.org>
References: <1324493221-4435-1-git-send-email-matt@console-pimps.org>
	<1324493221-4435-2-git-send-email-matt@console-pimps.org>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 21 Dec 2011 12:31:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt@console-pimps.org>
Date: Wed, 21 Dec 2011 18:47:00 +0000

> From: Matt Fleming <matt.fleming@intel.com>
> 
> Unlike other architectures, sparc currently has no SA_NODEFER
> definition but only the older SA_NOMASK. Since SA_NOMASK is the
> historical name for SA_NODEFER, add SA_NODEFER and copy what other
> architectures do by making SA_NOMASK a synonym for SA_NODEFER.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
