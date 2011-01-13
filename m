Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab1AMRqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:46:48 -0500
Received: from kroah.org ([198.145.64.141]:45980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825Ab1AMRqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:46:46 -0500
Date: Thu, 13 Jan 2011 09:43:32 -0800
From: Greg KH <greg@kroah.com>
To: =?utf-8?B?0J/QsNGB0LDRiNC90LjQutC+0LIg0JAu0JAu?= 
	<pepper@eatpbank.ru>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: JSM module patch
Message-ID: <20110113174332.GB28247@kroah.com>
References: <op.vo8g42gfgaomyf@pepper.eatpbank.ru>
 <op.vo8nbrx3gaomyf@pepper.eatpbank.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vo8nbrx3gaomyf@pepper.eatpbank.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 11:32:05AM +0300, Пасашников А.А. wrote:
> Hello
> 
> We use the OS Debian Squeeze kernel 2.6.32-5-686.
> There is a problem:
> We have an internal PCI card Digi Neo 4 with device ID 114F:00B0 (has 4
> COM-ports).
> Core module JSM doesn't support device described above, but support the
> same device with 8 COM-port and device ID 114F:00B1.
> Can you include this patches:

I would be glad to, if you can resend them in a format that I can apply
them in.  Hint, read the file, Documentation/SubmittingPatches and redo
your patch as it describes (properly level for patch, Signed-off-by:
line, etc.)

thanks,

greg k-h
