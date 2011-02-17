Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab1BQTiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:38:10 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:40567 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1BQTiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:38:07 -0500
Date: Thu, 17 Feb 2011 20:38:00 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] tty: serial: Updates for altera_uart driver
Message-ID: <20110217193800.GQ4076@distanz.ch>
References: <cover.1297244810.git.tklauser@distanz.ch> <cover.1297245277.git.tklauser@distanz.ch> <20110217193255.GA27139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217193255.GA27139@kroah.com>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-17 at 20:32:55 +0100, Greg KH <greg@kroah.com> wrote:
> On Wed, Feb 09, 2011 at 10:55:28AM +0100, Tobias Klauser wrote:
> > This patchset adds some updates to the altera_uart taken from the Nios2
> > Linux port (currently out-of-tree) repository, the most important one
> > probably being the added devicetree support.
> > 
> > Tobias Klauser (4):
> >   tty: serial: altera_uart: Handle pdev->id == -1 in altera_uart_remove
> >   tty: serial: altera_uart: Use port->regshift to store bus shift
> >   tty: serial: altera_uart: Add devicetree support
> >   MAINTAINERS: Add myself as a maintainer for
> >     altera_uart/altera_jtaguart
> 
> I've applied 3 of these patches, skipping the device tree patch, as it
> looks like you are going to rework it.

Yup, I'm currently waiting for a reply from Thomas and will update it
accordingly then. I'll send the updated patch later on (hopefully with
correct subject line this time).

Thanks a lot
Tobias
