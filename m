Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2FMUhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 16:37:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59278 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2FMUhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 16:37:33 -0400
Date: Wed, 13 Jun 2012 13:37:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        devel@linuxdriverproject.org
Subject: Re: misc: mei: fixes for 3.5
Message-ID: <20120613203729.GA11326@kroah.com>
References: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 04:39:08PM +0300, Tomas Winkler wrote:
> Hi Greg,
> please consider this batch for queuing into 3.5
> 1. patch 2/4 bug in probe: visible only after merging with the trunk
> 2. patch 3/4 fixes kernel oops that was revealed when probe failed
> 3. patch 4/4 is regression fix and should be merged also to stable 3.4
> 4. patch 1/4 is a minor documentation fix 

Grammer fixes are not ok for 3.5 at this point in time, sorry.  I'll
queue up the other 3 though.

greg k-h
