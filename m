Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab0D3Rex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:34:53 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33110 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933382Ab0D3Rei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:34:38 -0400
Date: Thu, 29 Apr 2010 23:30:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Matt Fleming <matt@console-pimps.org>, Mike Travis <travis@sgi.com>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/sh: Fix wrong function prototype for native_cpu_disable
Message-ID: <20100429143018.GC9621@linux-sh.org>
References: <201004290256.10506.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004290256.10506.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 02:56:10AM +0200, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch fixes the prototype of native_cpu_disable if
> CONFIG_HOTPLUG_CPU is not set, and thus fixes a build failure[1]
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2536296/
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

I've already applied Matt's patch for the same issue, thanks anyways!
