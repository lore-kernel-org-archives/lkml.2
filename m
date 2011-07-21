Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab1GUHyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:54:07 -0400
Received: from linux-sh.org ([111.68.239.195]:59579 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1GUHyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:54:05 -0400
Date: Thu, 21 Jul 2011 16:53:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Engraf <david.engraf@sysgo.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] shwdt: fix usage of mod_timer
Message-ID: <20110721075353.GC27831@linux-sh.org>
References: <4E26D22B.1040702@sysgo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E26D22B.1040702@sysgo.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 03:03:39PM +0200, David Engraf wrote:
> This patch fixes the usage of mod_timer and makes the driver usable. 
> mod_timer must be called with an absolute timeout in jiffies, the old 
> implementation used a relative timeout thus the hardware watchdog was 
> never triggered.
> 
> Signed-off-by: David Engraf <david.engraf@sysgo.com>
> 
Applied, thanks.
