Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1JZXQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:16:11 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35862 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab1JZXQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:16:09 -0400
Date: Wed, 26 Oct 2011 19:16:05 -0400 (EDT)
Message-Id: <20111026.191605.568124603250227730.davem@davemloft.net>
To: michael.hebenstreit@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: FATAL: kenrel too old - message
From: David Miller <davem@davemloft.net>
In-Reply-To: <B4E6F7EB08816A4692C7420D7E8F8CBD16EC546E@ORSMSX101.amr.corp.intel.com>
References: <B4E6F7EB08816A4692C7420D7E8F8CBD16EC546E@ORSMSX101.amr.corp.intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 26 Oct 2011 16:16:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Hebenstreit, Michael" <michael.hebenstreit@intel.com>
Date: Wed, 26 Oct 2011 23:04:04 +0000

> Can someone explain me why even an ldd on a dynamic executable gives
> a "kernel too old"? I understand that linking to a gcc that does not
> support the kernel causes this problem at runtime, but why does ldd
> fail? Are there other ways to diagnose this?

ldd is not a seperate tool on it's own.

It is implemented by executing the program under the dynamic linker
with special options and/or environment variables set which make the
dynamic linker print out the information requested.

Have a look at /usr/bin/ldd, it's just a shell script.

