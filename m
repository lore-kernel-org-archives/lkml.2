Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab0FXGDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 02:03:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:47650 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab0FXGDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 02:03:33 -0400
Subject: Re: [RFC 3/5] x86, trigger NMI return notifier soft_irq earlier
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1277348698-17311-3-git-send-email-ying.huang@intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	 <1277348698-17311-3-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 08:03:28 +0200
Message-ID: <1277359408.1875.831.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 11:04 +0800, Huang Ying wrote:
> soft_irq is used to run NMI return notifiers. But it may be quite long
> from soft_irq is raised in NMI handler to soft_irq is run actually. To
> solve the issue, a self interrupt IPI is used to trigger the soft_irq
> earlier.

This all is just gross hackery,..

wth is wrong with doing what I proposed earlier and use a work_struct
like callback mechanism?


