Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0DQGf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 02:35:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41860 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab0DQGf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 02:35:27 -0400
Date: Sat, 17 Apr 2010 08:35:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chetan Loke <generationgnu@yahoo.com>
Cc: rick.sherm@yahoo.com, andi@firstfloor.org, linux-numa@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Memory policy question for NUMA arch....
Message-ID: <20100417063523.GC18855@one.firstfloor.org>
References: <243351.5510.qm@web111910.mail.gq1.yahoo.com> <368225.78206.qm@web111904.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <368225.78206.qm@web111904.mail.gq1.yahoo.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I may be wrong but I think there's a difference. system-wide run-time default policy is M_PREFERRED | M_LOCAL and not Interleaving.

The policy at early kernel boot time (before mounting root) is interleaving.

-Andi
