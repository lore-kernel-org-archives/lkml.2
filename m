Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab0ILTJb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:09:31 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55206 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab0ILTJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:09:30 -0400
Date: Sun, 12 Sep 2010 21:09:29 +0200
From: Andreas Mohr <andi@lisas.de>
To: Louis-David Mitterrand <vindex+lists-linux-kernel@apartia.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ksoftirqd/n permanently eating 60% of a CPU
Message-ID: <20100912190929.GA16932@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912154138.GA23554@apartia.fr>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

doh, I should have remembered to state the possibly easiest way to discover
things:
try Alt-SysRq-T or Alt-SysRq-Q (or via /proc/sysrq-trigger if needed).

Andreas Mohr
