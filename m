Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2DBWLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:11:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44830 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2DBWLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:11:47 -0400
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
In-Reply-To: <4F77C75B.4060105@intel.com>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
	 <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>
	 <1333163902.2960.63.camel@laptop>  <4F77C75B.4060105@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Apr 2012 00:11:33 +0200
Message-ID: <1333404693.2960.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 11:11 +0800, Yan, Zheng wrote:
> 
> Because using per-cpu allocation is inconvenience for PCI uncore device.

What are those, where does one read about them and why?

