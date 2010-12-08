Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0LHOPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:15:42 -0500
Received: from www.tglx.de ([62.245.132.106]:33633 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab0LHOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:15:41 -0500
Date: Wed, 8 Dec 2010 15:15:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: sodaville@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [sodaville] [PATCH 01/11] x86/kernel: remove conditional early
 remap in parse_e820_ext
In-Reply-To: <20101208083821.GA22579@www.tglx.de>
Message-ID: <alpine.LFD.2.00.1012081514340.2653@localhost6.localdomain6>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-2-git-send-email-bigeasy@linutronix.de> <20101208083821.GA22579@www.tglx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, Sebastian Andrzej Siewior wrote:
> 
> Nobody commented this and haven't seen it merged. Is it good to go?

Yup. It's in my list of stuff to take care of :)

Thanks,

	tglx
