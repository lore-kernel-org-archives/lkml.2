Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2CLPKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:10:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab2CLPKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:10:49 -0400
Date: Mon, 12 Mar 2012 16:10:40 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] genirq: Get rid of unnecessary IRQTF_DIED flag
Message-ID: <20120312151039.GB2390@dhcp-26-207.brq.redhat.com>
References: <20120309135958.GD2114@dhcp-26-207.brq.redhat.com>
 <20120309150612.GA7353@redhat.com>
 <alpine.LFD.2.02.1203091716260.2742@ionos>
 <20120312113830.GA2390@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312113830.GA2390@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 12:38:30PM +0100, Alexander Gordeev wrote:

> If my considerations are flawed I will repost the patch with the original
> order as it indeed reads better :)

Thomas, please nevermind my last note.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
