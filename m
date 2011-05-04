Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1EDUjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:39:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52963 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab1EDUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:39:16 -0400
Date: Wed, 4 May 2011 22:39:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] Kdump and memory error handling
Message-ID: <20110504203914.GC1737@one.firstfloor.org>
References: <20110504193509.GA5342@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110504193509.GA5342@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any thoughts/suggestions?

My old attempts to solve this are

Don't dump on MCE:

http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=shortlog;h=refs/heads/mce/xpanic

Handle dumps of corrupted memory regresions:

http://git.kernel.org/?p=linux/kernel/git/ak/linux-mce-2.6.git;a=shortlog;h=refs/heads/mce/crashdump

IMHO these patches are still the right solutions for this.

-Andi
