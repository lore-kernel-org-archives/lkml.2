Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026Ab2HIXlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 19:41:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49805 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759767Ab2HIXlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 19:41:17 -0400
Date: Fri, 10 Aug 2012 01:41:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Betty Dall <betty.dall@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86, pci: Fix all early PCI scans to check the vendor ID first
Message-ID: <20120809234111.GD11413@one.firstfloor.org>
References: <1344464246-14618-1-git-send-email-andi@firstfloor.org> <1344551691.10751.12.camel@ejdallLaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344551691.10751.12.camel@ejdallLaptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Betty. All fixed. I'll post a v2.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
