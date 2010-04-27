Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0D0Mnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:43:37 -0400
Received: from tex.lwn.net ([70.33.254.29]:54563 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab0D0Mnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:43:32 -0400
Date: Tue, 27 Apr 2010 06:43:29 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Ball <cjb@laptop.org>
Subject: Re: linux-next: build failure after merge of the final tree (viafb
 tree related)
Message-ID: <20100427064329.226e623d@bike.lwn.net>
In-Reply-To: <20100427154925.7315ed67.sfr@canb.auug.org.au>
References: <20100427154925.7315ed67.sfr@canb.auug.org.au>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 15:49:25 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/video/via/hw.c:21:22: error: asm/olpc.h: No such file or directory

Interesting...I assume this was a non-x86 build?  Viafb should, I
think, always be x86-only...I can put in a fix for that.  Sorry for the
trouble.

jon
