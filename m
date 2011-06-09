Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab1FIPsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:48:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab1FIPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:48:22 -0400
MIME-Version: 1.0
In-Reply-To: <1307629417.3941.89.camel@twins>
References: <20110609130647.937204592@chello.nl> <20110609131307.590149293@chello.nl>
 <20110609133228.GB21100@elte.hu> <1307626856.3941.80.camel@twins>
 <20110609135542.GD21100@elte.hu> <1307628393.3941.87.camel@twins>
 <20110609141959.GF21100@elte.hu> <1307629417.3941.89.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Jun 2011 08:47:58 -0700
Message-ID: <BANLkTinbBwH-An0-id6YhCSah_p_bfkVtw@mail.gmail.com>
Subject: Re: [PATCH 3/3] printk: Avoid all wakeups from printk
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, efault@gmx.de,
        Arne Jansen <lists@die-jansens.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 7:23 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Subject: printk: Avoid all wakeups from printk
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Jun 08 17:29:59 CEST 2011

Looks good to me.  Is it working? You said that some early version of
this caused problems for Ingo?

                      Linus
