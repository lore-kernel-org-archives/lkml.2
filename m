Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1JXWvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1JXWvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:51:20 -0400
Date: Mon, 24 Oct 2011 18:51:08 -0400
From: Dave Jones <davej@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix kmalloc argument order in um/vdso/vma.c
Message-ID: <20111024225108.GA25654@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20111024221532.GA22671@redhat.com>
 <4EA5E573.3080006@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA5E573.3080006@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:23:47AM +0200, Richard Weinberger wrote:
 > Am 25.10.2011 00:15, schrieb Dave Jones:
 > > kmalloc size is 1st arg, not second.
 > > 
 > > Signed-off-by: Dave Jones <davej@redhat.com>
 > 
 > Applied, Thanks!
 > 
 > I'm a bit shocked that this obviously wrong code builds and seems to work.

Both args are the same types, so gcc didn't know any better.

 > How have you found this?

grep -r kmalloc\(GFP *

	Dave

