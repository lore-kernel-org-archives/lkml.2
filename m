Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1G0GGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:06:04 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:50343 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1G0GGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:06:02 -0400
Date: Wed, 27 Jul 2011 08:05:45 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] proc/insterrupts: make it cpu hotplug safe
Message-ID: <20110727060545.GA2561@osiris.boeblingen.de.ibm.com>
References: <20110726163424.GC2576@osiris.boeblingen.de.ibm.com>
 <1311742583-18633-1-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311742583-18633-1-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:56:22PM +0800, Yong Zhang wrote:
> KOSAKI Motonhiro noticed that the reader of /proc/interrupts
> could be preempted by cpu hotplug, thus the reader can get
> broken result due to show_interrupts() iterate every online
> cpu without any protection.
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
