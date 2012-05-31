Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2EaQSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:18:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40206 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2EaQSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:18:45 -0400
Date: Thu, 31 May 2012 12:11:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
Message-ID: <20120531161139.GA13939@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 12:57:44PM +0000, Liu, Jinsong wrote:
> >From 1a7951d6ca01d7f2c9dd2bdb6de5f8e7fdcb8bbd Mon Sep 17 00:00:00 2001
> From: root <root@ljsromley.bj.intel.com>

Also your git author is busted. I fixed it up for you but
you might want to run 'git config --user.name' and such

> Date: Fri, 1 Jun 2012 03:12:51 +0800
> Subject: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform

What about the cvt_gate_to_trap? Does that need something similar
to "xen/mce: Register native mce handler as vMCE bounce back point"
?

I stuck all these patches on devel/mce.v2 on
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git


