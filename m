Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2F1KK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 06:10:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51108 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab2F1KKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:10:48 -0400
Message-ID: <1340878232.28750.6.camel@twins>
Subject: Re: [PATCH 2/2] perf/x86: Uncore Filter support for SandyBridge-EP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: eranian@google.com, mingo@elte.hu, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Jun 2012 12:10:32 +0200
In-Reply-To: <4FEBB3A9.6090906@intel.com>
References: <1340780953-21130-1-git-send-email-zheng.z.yan@intel.com>
	  <1340780953-21130-2-git-send-email-zheng.z.yan@intel.com>
	 <1340791604.10063.10.camel@twins> <4FEBB3A9.6090906@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 09:30 +0800, Yan, Zheng wrote:
> > Isn't the uncore now suffering the same problem you found for the
> > regular extra stuff?
> 
> The snbep_uncore_get/put_constraint(...) has check for that. The uncore case is simpler,
> because we don't need try swapping RSP_0/RSP_1. 

The fact that I missed that is a big hint..
