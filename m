Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1HCXms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:42:48 -0400
Received: from smtp13.ono.com ([62.42.230.16]:34051 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932113Ab1HCXmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:42:37 -0400
Date: Thu, 4 Aug 2011 01:42:34 +0200
From: JA Magallon <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Metadata space in BTRFS
Message-ID: <20110804014234.01d9f05a@werewolf.home>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

Just a simple question.
I'm trying to use a 16GB SDHC card formatted in btrfs, and the system
eats about 2GB for its metadata space. When the card fills, the
situation is like this:

werewolf:/media/home# btrfs fi df .
Data: total=13.22GB, used=13.22GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=58.43MB
Metadata: total=8.00MB, used=0.00

I lose about 2Gb wrt ext4. Is there any way to shrink this metadata
space ?

TIA

