Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1B1JSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:18:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:58839 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1B1JSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:18:40 -0500
Subject: Re: perf: fix the missing event initialization when pmu is found
 in idr
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1298812411.2699.9.camel@localhost>
References: <1298812411.2699.9.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Feb 2011 10:18:27 +0100
Message-ID: <1298884707.2428.10090.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-27 at 21:13 +0800, Lin Ming wrote:
> Currently, the event is not initialized if pmu is found in idr.
> This never causes bug just because now no pmu is associated with the
> idr id. 

Yeah, d'0h, thanks!
