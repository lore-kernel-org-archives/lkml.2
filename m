Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1B1VTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:19:53 -0500
Received: from kroah.org ([198.145.64.141]:55174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906Ab1B1VTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:19:52 -0500
Date: Mon, 28 Feb 2011 13:19:25 -0800
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: RFC: [PATCH 4/5] staging: sep: update sep_main.c for kernel
 crypto operation
Message-ID: <20110228211925.GD8851@kroah.com>
References: <1298869909-4394-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298869909-4394-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 27, 2011 at 09:11:49PM -0800, Mark Allyn wrote:
> These changes include new functions required by the sep_crypto.c
> file (to be added in subsequent patch) as well as alterations
> in interrupt handler.

You just broke the build.  Don't do that.

greg k-h
