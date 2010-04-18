Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab0DRRje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 13:39:34 -0400
Received: from tex.lwn.net ([70.33.254.29]:40453 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab0DRRjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 13:39:33 -0400
Date: Sun, 18 Apr 2010 11:39:30 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 07/16] viafb: Add 1200x900 DCON/LCD panel modes for OLPC
 XO-1.5
Message-ID: <20100418113930.1ba08ee3@bike.lwn.net>
In-Reply-To: <4BBF9BC2.9070502@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-8-git-send-email-corbet@lwn.net>
	<4BBF9BC2.9070502@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Apr 2010 23:27:30 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> What will happen if someone with no VX855 will try to enter 1200x900 
> mode? Probably the world won't be destroyed but I have a really ugly 
> feeling that the driver is not well prepared for this situation. 

OK, I'm certainly exposing my relative lack of understanding of
framebuffer issues (I'm here to add a camera driver, remember? :),
but...is this really something that older chipsets can't handle?  Or is
it just that nobody has had that size of panel before?

> Haven't 
> tested yet as I'm waiting for the official forward port but I think it 
> might be better to reschedule this patch for later or add some PLL 
> values that are supposed to work (using/executing the formulas in the 
> VIA open source X driver)

If it's really not acceptable, then it will stay out, but I would
rather get it merged.  I will leave it in the series for now; it can
come out later if need be.

Thanks,

jon
