Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1JTIts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:49:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39786 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1JTItr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:49:47 -0400
Date: Thu, 20 Oct 2011 04:48:43 -0400 (EDT)
Message-Id: <20111020.044843.1562615208158270555.davem@davemloft.net>
To: cjren@qca.qualcomm.com
Cc: romieu@fr.zoreil.com, rodrigue@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch net-next]alx: Atheros AR8131/AR8151/AR8152/AR8161
 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <6349D7A510622448B1BA0967850A8438011CC12D@nasanexd02d.na.qualcomm.com>
References: <1319009213-20627-1-git-send-email-cloud.ren@atheros.com>
	<20111019222140.GA9937@electric-eye.fr.zoreil.com>
	<6349D7A510622448B1BA0967850A8438011CC12D@nasanexd02d.na.qualcomm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 20 Oct 2011 01:48:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ren, Cloud" <cjren@qca.qualcomm.com>
Date: Thu, 20 Oct 2011 07:29:27 +0000

> Thanks for your information.
> 
> Drivers on different OSs share alf_hw.c, alf_hw.h, alc_hw.c and alc_hw.h
> 
> So it looks some of codes are duplicate, because other drivers need them.

You cannot do this, you must get rid of such compatability wrappers
and unused code.
