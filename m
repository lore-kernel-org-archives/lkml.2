Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1AaQan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:30:43 -0500
Received: from kroah.org ([198.145.64.141]:46361 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755246Ab1AaQam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:30:42 -0500
Date: Mon, 31 Jan 2011 08:30:35 -0800
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Remove drivers/staging/vme/bridges/Module.symvers file
Message-ID: <20110131163035.GA23065@kroah.com>
References: <4D46DF75.6010902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D46DF75.6010902@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 02:12:37PM -0200, Mauro Carvalho Chehab wrote:
> This file is auto-generated/auto-removed. It shouldn't be
> committed at the tree.
> 
> This caused me some hurt, as, depending if I did a make
> clean or not, a "git commit -a" ends folding this file
> removal, mangling my patches.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Thanks, this has just been sent off to Linus, it was in my staging-linus
tree for a week or so.

greg k-h
