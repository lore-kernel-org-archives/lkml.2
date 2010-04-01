Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab0DAPtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:49:40 -0400
Received: from kroah.org ([198.145.64.141]:55726 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823Ab0DAPte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:49:34 -0400
Date: Thu, 1 Apr 2010 08:49:09 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: robert.richter@amd.com, oprofile-list@lists.sf.net,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, stable@kernel.org
Subject: Re: [stable] [PATCH] oprofile: remove double ring buffering
Message-ID: <20100401154909.GA13527@kroah.com>
References: <20100401011725.GA27567@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401011725.GA27567@basil.fritz.box>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 03:17:25AM +0200, Andi Kleen wrote:
> Got confirmation now this patch fixes most of the dropped oprofile
> samples problem on a particular intensive test on a large system.
> So now submitting the previous RFC formally.
> .34 / Stable candidate.

For automatic inclusion in stable trees when the patch goes into Linus's
tree, just add:
	Cc: stable <stable@kernel.org>
to the Signed-off-by: area of the patch and we will be automatically
notified of it and you will not have to do anything else (and I will not
have to dig through the git trees to see if it has been commited or not,
and if so, what the id is...)

thanks,

greg k-h
