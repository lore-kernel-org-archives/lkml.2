Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2J3KFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:05:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:48981 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab2J3KFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:05:13 -0400
Date: Tue, 30 Oct 2012 11:05:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.6.4-rt10
In-Reply-To: <alpine.LFD.2.02.1210290957290.2756@ionos>
Message-ID: <alpine.LFD.2.02.1210301103350.2756@ionos>
References: <alpine.LFD.2.02.1210290957290.2756@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, Thomas Gleixner wrote:

> Dear RT Folks,
> 
> I'm pleased to announce the 3.6.4-rt10 release. This is just an update
> to 3.6.4 with no RT related changes

FYI, please disable SLUB and switch back to SLAB. Seems I took a bit
too naive approach of making it suitable for RT.

Thanks,

	tglx
