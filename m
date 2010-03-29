Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab0C2B7X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 21:59:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41415
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557Ab0C2B7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 21:59:21 -0400
Date: Sun, 28 Mar 2010 18:59:45 -0700 (PDT)
Message-Id: <20100328.185945.253510769.davem@davemloft.net>
To: david@fries.net
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: revert request "ide: skip probe if there are no devices on the
 port (v2)"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100328212728.GA2674@spacedout.fries.net>
References: <20100328212728.GA2674@spacedout.fries.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <david@fries.net>
Date: Sun, 28 Mar 2010 16:27:28 -0500

> Now that I have 2.6.34-rc2 booting it no longer detects the cdrom
> drive.  That is looking at the kernel messages, partition dump, and
> after booting hdparm etc does not find the drive.  I expect it is
> because the cdrom is a slave drive without a master on that ribbon.
> Reverting

Reverted, thanks for the report David.
