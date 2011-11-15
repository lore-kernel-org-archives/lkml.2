Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1KOUWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:22:14 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33660 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176Ab1KOUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:22:12 -0500
X-Sasl-enc: HnrctH81EBEdmOnQ47uLIJ/8raA8QWI03w9CzIpVDGUQ 1321388531
Date: Tue, 15 Nov 2011 12:18:00 -0800
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tty: make several fops functions non-static so that
 the pty code can use them
Message-ID: <20111115201800.GA10551@kroah.com>
References: <20111030094038.7046d529@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111030094038.7046d529@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 30, 2011 at 09:40:38AM -0700, Arjan van de Ven wrote:
> 
> From 7e5c44c1d42a1e66ea5df069f3f8ee50a5c46168 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sat, 29 Oct 2011 10:41:19 -0700
> Subject: [PATCH 1/3] tty: make several fops functions non-static so that the pty code can use them
> 
> The pty code currently does a partial function-pointer copy to fill its
> struct file_operations; this patch makes the functions it copies non-static
> in preparation of switching the pty code over to using proper prototypes.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

Next time, please use 'git send-email' to send your patches out so that
I don't have to manually edit them by hand to get them to apply properly

:(

greg k-h
