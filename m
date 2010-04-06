Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab0DFX2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 19:28:43 -0400
Received: from tex.lwn.net ([70.33.254.29]:47545 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586Ab0DFX2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 19:28:38 -0400
Date: Tue, 6 Apr 2010 17:28:36 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Documentation/development-process: update staging
 info
Message-ID: <20100406172836.0df579a1@bike.lwn.net>
In-Reply-To: <20100406161728.06033494.randy.dunlap@oracle.com>
References: <20100406161728.06033494.randy.dunlap@oracle.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 16:17:28 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> +Besides the mmotm and linux-next trees, the kernel source tree now contains
> +the drivers/staging/ directory and many sub-directories for drivers or
> +filesystems that are on their way to being added to the kernel tree
> +proper, but they remain in drivers/staging/ while they still need more
> +work.

It would be better to add a proper section on staging, but, certainly,
I've not gotten around to that.  This is an improvement, anyway, so you
can add my acked-by on this one too.

Thanks,

jon
