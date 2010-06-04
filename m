Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0FDQyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:54:31 -0400
Received: from kroah.org ([198.145.64.141]:55704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0FDQya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:54:30 -0400
Date: Fri, 4 Jun 2010 09:54:11 -0700
From: Greg KH <greg@kroah.com>
To: Himanshu Chauhan <hschauhan@nulltrace.org>
Cc: linux-kernel@vger.kernel.org, usbip-devel@lists.sourceforge.net
Subject: Re: [PATCH] staging: usbip: usbip_common: kill rx thread on tx
 thread creation error.
Message-ID: <20100604165411.GB27275@kroah.com>
References: <1275324817-4810-1-git-send-email-hschauhan@nulltrace.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275324817-4810-1-git-send-email-hschauhan@nulltrace.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:23:37PM +0530, Himanshu Chauhan wrote:
> Signed-off-by: Himanshu Chauhan <hschauhan@nulltrace.org>
> ---
>  drivers/staging/usbip/usbip_common.c |   46 ++++++++++++++++++++++++---------

This patch doesn't apply, what tree did you make it against?  Can you
please redo it against the 2.6.35-rc1 release?

thanks,

greg k-h
