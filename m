Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0DJAzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:55:09 -0400
Received: from tex.lwn.net ([70.33.254.29]:55495 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0DJAzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:55:06 -0400
Date: Fri, 9 Apr 2010 18:55:01 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/16] viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5
Message-ID: <20100409185501.3164fb90@bike.lwn.net>
In-Reply-To: <4BBFC98C.5010805@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-9-git-send-email-corbet@lwn.net>
	<4BBF9EE7.50707@gmx.de>
	<20100409181942.175b375a@bike.lwn.net>
	<4BBFC98C.5010805@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Apr 2010 02:42:52 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> > That said, machine_is_olpc() is properly defined for all
> > configurations, so the #ifdefs can (and should) come out.  
> 
> I'm not sure I get you right here. If you talk about removing the 
> defines and only letting the machine check that is something that I 
> would accept now. 

Yes, that is what I mean; the ifdefs don't need to be there.  Had I
thought that through I would have removed them before posting the patch.

jon
