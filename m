Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab1G0GGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:06:11 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:50390 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1G0GGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:06:07 -0400
Date: Wed, 27 Jul 2011 08:06:05 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/2] [S390] irq: fix show_interrupts() vs cpu hotplug
Message-ID: <20110727060605.GB2561@osiris.boeblingen.de.ibm.com>
References: <20110726163424.GC2576@osiris.boeblingen.de.ibm.com>
 <1311742583-18633-1-git-send-email-yong.zhang0@gmail.com>
 <1311742583-18633-2-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311742583-18633-2-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:56:23PM +0800, Yong Zhang wrote:
> The current usage of get_online_cpus()/put_online_cpus()
> in show_interrupts() is not correct since show_interrupts()
> will be called nr_irqs times, during that period, cpu hotplug
> could also happen.
> Since have moved the protection to upper(patch#1), the pair of
> get_online_cpus()/put_online_cpus() could be removed here.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
