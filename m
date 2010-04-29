Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568Ab0D3SCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:02:39 -0400
Received: from kroah.org ([198.145.64.141]:40640 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841Ab0D3Rdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:33:32 -0400
Date: Thu, 29 Apr 2010 09:55:38 -0700
From: Greg KH <greg@kroah.com>
To: Imtiaz Rahi <imtiaz.rahi@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192su: fix various coding style issues in
 r8180_93cx6.c
Message-ID: <20100429165538.GB18228@kroah.com>
References: <1268966823-15418-1-git-send-email-imtiaz.rahi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268966823-15418-1-git-send-email-imtiaz.rahi@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 08:47:03AM +0600, Imtiaz Rahi wrote:
> This is patch to the r8180_93cx6.c file that fixes various coding style
> warnings and errors found by checkpatch.pl
> 
> Signed-off-by: Imtiaz Rahi <imtiaz.rahi@gmail.com>

This no longer applies due to other changes to the driver in the
linux-next tree.  Can you redo it against the linux-next tree of
tomorrow?

thanks,

greg k-h
