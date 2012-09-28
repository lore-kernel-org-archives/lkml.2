Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031170Ab2I1T0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:26:47 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57677 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031156Ab2I1T0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:26:43 -0400
Date: Fri, 28 Sep 2012 15:26:40 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Mason <chris.mason@fusionio.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ 173/262] mutex: Place lock in contended state after fastpath_lock
 failure
In-Reply-To: <20120928183018.432178544@linuxfoundation.org>
Message-ID: <alpine.LFD.2.02.1209281522360.6667@xanadu.home>
References: <20120928182957.993484211@linuxfoundation.org> <20120928183018.432178544@linuxfoundation.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Greg Kroah-Hartman wrote:

> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.5-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Will Deacon <will.deacon@arm.com>
> 
> commit 0bce9c46bf3b15f485d82d7e81dabed6ebcc24b1 upstream.

Now that you've queued this one, could you pick up a76d7bd96d as well 
please?

Thanks


Nicolas
