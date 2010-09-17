Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0IQUez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:34:55 -0400
Received: from www.tglx.de ([62.245.132.106]:42852 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab0IQUey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:34:54 -0400
Date: Fri, 17 Sep 2010 22:34:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] uio: Cleanup irq handling.
In-Reply-To: <m1k4mo893j.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1009172234060.2416@localhost6.localdomain6>
References: <m1y6b48973.fsf@fess.ebiederm.org> <m1k4mo893j.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Eric W. Biederman wrote:

> 
> Change the value of UIO_IRQ_NONE -2 to 0.  0 is well defined in the rest
> of the kernel as the value to indicate an irq has not been assigned.
> 
> Update the calls to request_irq and free_irq to only ignore UIO_IRQ_NONE
> and UIO_IRQ_CUSTOM allowing the rest of the kernel's possible irq
> numbers to be used.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
 
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
