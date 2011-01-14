Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab1ANTAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:00:36 -0500
Received: from smtp204.alice.it ([82.57.200.100]:48180 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057Ab1ANTAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:00:34 -0500
From: Alberto Mattea <alberto@mattea.info>
To: linux-kernel@vger.kernel.org
Subject: Re: sata_nv silently ignores discard (TRIM) command?
Date: Fri, 14 Jan 2011 20:00:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-020637-generic; KDE/4.5.5; x86_64; ; )
References: <201101141850.25252@alby> <201101141936.11923@alby> <x49fwsv9uty.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49fwsv9uty.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101142000.31669@alby>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> That means that discarded blocks are not zeroed.  The trim was likely
> processed just fine.
> 
> Cheers,
> Jeff

Thanks a lot! I was already worrying about changing motherboard.
Bye
Alberto
