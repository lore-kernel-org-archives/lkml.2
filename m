Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896Ab0FQXIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:08:01 -0400
Received: from kroah.org ([198.145.64.141]:42918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760864Ab0FQXHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:07:33 -0400
Date: Thu, 17 Jun 2010 16:03:13 -0700
From: Greg KH <greg@kroah.com>
To: Henri =?iso-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, rich.folsom@gmail.com,
       mithlesh@linsyssoft.com, jirislaby@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:comedi: Fixed coding conventions on
 `adl_pci9111.c'
Message-ID: <20100617230313.GA419@kroah.com>
References: <1276502691-5573-1-git-send-email-henuxd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276502691-5573-1-git-send-email-henuxd@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:04:51AM +0300, Henri Häkkinen wrote:
> Cleaned up and fixed coding convention issues as reported by checkpatch.pl
> on the file `drivers/adl_pci9111.c' as well as other minor changes for
> consistency and clarity.

For some reason, parts of this patch no longer apply.  Can you redo it
against the latest linux-next tree and resend it?

thanks,

greg k-h
