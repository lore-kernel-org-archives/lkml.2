Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0LAQLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:11:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:46840 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab0LAQLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:11:41 -0500
Date: Wed, 1 Dec 2010 08:10:39 -0800
From: Greg KH <gregkh@suse.de>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: whci-hcd: fix compiler warning
Message-ID: <20101201161039.GB29318@suse.de>
References: <1291177721-17598-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291177721-17598-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 01:28:41PM +0900, Namhyung Kim wrote:
> Annotate whci_hcd_id_table as '__used' to fix following warning:
> 
>   CC      drivers/usb/host/whci/hcd.o
> drivers/usb/host/whci/hcd.c:359: warning: ‘whci_hcd_id_table’ defined but not used

Are you seeing this warning when you build the module into the kernel,
or as a module?

thanks,

greg k-h
