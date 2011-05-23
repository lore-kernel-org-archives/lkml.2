Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab1EWUKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:10:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:46615 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab1EWUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:10:51 -0400
Subject: Re: [PATCH] sched: track "isolated" cpus like other cpu masks.
From: Peter Zijlstra <peterz@infradead.org>
To: Geoff Thorpe <geoff@geoffthorpe.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1305923374-13274-1-git-send-email-geoff@geoffthorpe.net>
References: <1305923374-13274-1-git-send-email-geoff@geoffthorpe.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 22:14:09 +0200
Message-ID: <1306181649.2497.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 16:29 -0400, Geoff Thorpe wrote:
> When a subset of cpus have been isolated, it can be useful for subsystems
> or drivers that have cpu-affinity concerns to have access to this mask
> (just like the other cpu masks; "possible", "present", "active" and
> "online"). Eg. to provide specific handling for isolated cpus, or to
> determine the non-isolated cpus (which is what sched.c uses it for).

Nobody should be using that, isolated CPUs is a 'feature' slated for
removal.

