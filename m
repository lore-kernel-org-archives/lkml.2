Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab0DSPd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 11:33:27 -0400
Received: from www84.your-server.de ([213.133.104.84]:34678 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0DSPdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 11:33:25 -0400
Subject: Re: [PATCH 2/4] remove the old non generic API
From: Stefani Seibold <stefani@seibold.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       andi@firstfloor.org, alan@lxorguk.ukuu.org.uk, tytso@mit.edu,
       iws@ovro.caltech.edu
In-Reply-To: <20100419152856.GC11553@suse.de>
References: <1271624718-8256-1-git-send-email-stefani@seibold.net>
	 <1271624718-8256-3-git-send-email-stefani@seibold.net>
	 <20100419152856.GC11553@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 19 Apr 2010 17:33:04 +0200
Message-ID: <1271691184.12238.2.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 19.04.2010, 08:28 -0700 schrieb Greg KH:
> On Sun, Apr 18, 2010 at 11:05:16PM +0200, stefani@seibold.net wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > This patch simple remove the whole kfifo.c and kfifo.h files. The next
> > patch will replace it with the new generic kfifo API.
> 
> But you just broke the kernel build at this point in the patch sequence,
> which is not allowed :(
> 

I know, but the only way is to merge the patch 2 and 3 together which
results in a very large and unreadable patch.

If desired i will do this...

Stefani


