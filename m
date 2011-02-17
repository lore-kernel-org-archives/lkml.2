Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1BQTdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:33:35 -0500
Received: from kroah.org ([198.145.64.141]:40869 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1BQTdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:33:32 -0500
Date: Thu, 17 Feb 2011 11:32:55 -0800
From: Greg KH <greg@kroah.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] tty: serial: Updates for altera_uart driver
Message-ID: <20110217193255.GA27139@kroah.com>
References: <cover.1297244810.git.tklauser@distanz.ch>
 <cover.1297245277.git.tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1297245277.git.tklauser@distanz.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 10:55:28AM +0100, Tobias Klauser wrote:
> This patchset adds some updates to the altera_uart taken from the Nios2
> Linux port (currently out-of-tree) repository, the most important one
> probably being the added devicetree support.
> 
> Tobias Klauser (4):
>   tty: serial: altera_uart: Handle pdev->id == -1 in altera_uart_remove
>   tty: serial: altera_uart: Use port->regshift to store bus shift
>   tty: serial: altera_uart: Add devicetree support
>   MAINTAINERS: Add myself as a maintainer for
>     altera_uart/altera_jtaguart

I've applied 3 of these patches, skipping the device tree patch, as it
looks like you are going to rework it.

thanks,

greg k-h
