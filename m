Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab1ANSgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:36:16 -0500
Received: from smtp204.alice.it ([82.57.200.100]:57581 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757718Ab1ANSgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:36:16 -0500
From: Alberto Mattea <alberto@mattea.info>
To: linux-kernel@vger.kernel.org
Subject: Re: sata_nv silently ignores discard (TRIM) command?
Date: Fri, 14 Jan 2011 19:36:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-020637-generic; KDE/4.5.5; x86_64; ; )
References: <201101141850.25252@alby> <x49mxn39vzm.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mxn39vzm.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101141936.11923@alby>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data venerdì 14 gennaio 2011 19:32:45, Jeff Moyer ha scritto:
> 
> What does 'cat /sys/block/sda/queue/discard_zeroes_data' say?
> 
> Cheers,
> Jeff
Hi Jeff, it says 0. So I assume it's not working?
Thanks
Alberto
