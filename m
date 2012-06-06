Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2FFKkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:40:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51245 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2FFKkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:40:35 -0400
Message-ID: <1338979224.2749.93.camel@twins>
Subject: Re: [PATCH 3/5] perf, x86: Check LBR format capability
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Date: Wed, 06 Jun 2012 12:40:24 +0200
In-Reply-To: <1338944211-28275-3-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
	 <1338944211-28275-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Double check the CPU has a LBR format we support before using it.
> 
> Also I made the init functions __init while I was on it. 

Why? Its all after a model test anyway.
