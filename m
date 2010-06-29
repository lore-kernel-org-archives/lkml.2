Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627Ab0F2Q3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:29:40 -0400
Received: from legolas.restena.lu ([158.64.1.34]:37781 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755673Ab0F2Q3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:29:39 -0400
Date: Tue, 29 Jun 2010 18:28:59 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alexander Clouter <alex@digriz.org.uk>, Dmitry Torokhov <dtor@vmware.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] VMware balloon: force compiling as a module
Message-ID: <20100629182859.5acd5be7@neptune.home>
In-Reply-To: <vcnof7-b9p.ln1@chipmunk.wormnet.eu>
References: <20100628230035.GA18971@dtor-ws.eng.vmware.com>
	<vcnof7-b9p.ln1@chipmunk.wormnet.eu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 June 2010 Alexander Clouter <alex@digriz.org.uk> wrote:
> Dmitry Torokhov <dtor@vmware.com> wrote:
> >
> > VMware Tools installer requires the upstream driver to be compiled
> > as a module in order to detect its presence and avoid installing
> > our own version on top of it. To avoid surprises with 2 versions
> > of the driver being installed and fighting with each other, let's
> > force the driver to be compiled as a module unless user selects
> > CONFIG_EMBEDDED.
> >
> *barf*
> 
> This surely is a problem in the installer and not the kernel?  Can you 
> not nosey around in /sys/class/misc or where-ever your driver appears?  
> If it does not, then I would probably suggest a patch to your balloon 
> driver that dumps some details in there, including module version 
> information.
> 
> Eugh.

In addition, the installer may check under /sys/module/ for it (as for
any/most code that can be built as a module), even for built-in code.
(if balloon driver does not show up there when built-in it would be
better to get it to show up there)

Bruno
