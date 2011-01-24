Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab1AXSsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:48:06 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34640 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab1AXSsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:48:04 -0500
Subject: Re: [PATCH] ARM: mm: Regarding section when dealing with meminfo
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: KyongHo Cho <pullip.cho@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        KeyYoung Park <keyyoung.park@samsung.com>,
        linux-kernel@vger.kernel.org, Ilho Lee <ilho215.lee@samsung.com>,
        linux-mm@kvack.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110124175807.GA27427@n2100.arm.linux.org.uk>
References: <1295516739-9839-1-git-send-email-pullip.cho@samsung.com>
	 <1295544047.9039.609.camel@nimitz>
	 <20110120180146.GH6335@n2100.arm.linux.org.uk>
	 <1295547087.9039.694.camel@nimitz>
	 <20110123180532.GA3509@n2100.arm.linux.org.uk>
	 <1295887937.11047.119.camel@nimitz>
	 <20110124175807.GA27427@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Mon, 24 Jan 2011 10:47:37 -0800
Message-ID: <1295894857.11047.556.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 17:58 +0000, Russell King - ARM Linux wrote:
> Wrong.  For flatmem, we have a pfn_valid() which is backed by doing a
> one, two or maybe rarely three compare search of the memblocks.  Short
> of having a bitmap of every page in the 4GB memory space, you can't
> get more efficient than that.

Sweet.  So, we can just take the original patch that started this
conversation, add the requisite pfn_valid()s and pfn_to_page()s, and
skip the sparsemem #ifdefs.  Right?

-- Dave

