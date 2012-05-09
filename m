Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab2EIWoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:44:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53757 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab2EIWoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:44:15 -0400
Date: Wed, 9 May 2012 15:44:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: vaLentin chernoZemski <valentin@siteground.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.2.14 - Sporadic HARD
 lockups/__slab_free/intel_pmu_handle_irq->perf_event_overflow
Message-ID: <20120509224411.GA8872@kroah.com>
References: <4FA8D8A7.8020704@siteground.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA8D8A7.8020704@siteground.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 11:26:15AM +0300, vaLentin chernoZemski wrote:
> Kindly Note that kernel is patched against grsec but grsec is not
> enabled inside the kernel configuration.

Can you duplicate this without the grsec code patched into the kernel?

thanks,

greg k-h

