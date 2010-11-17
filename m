Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935441Ab0KQUGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:06:17 -0500
Received: from SMTP03.SRV.CS.CMU.EDU ([128.2.217.198]:43865 "EHLO
	smtp03.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935344Ab0KQUGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:06:16 -0500
Date: Wed, 17 Nov 2010 15:06:14 -0500
From: Eric Cooper <ecc@cmu.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add netdev led trigger
Message-ID: <20101117200614.GK15096@localhost>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <1289768305-1224-1-git-send-email-ecc@cmu.edu>
 <20101117105925.GC1574@ucw.cz>
 <20101117160919.GC10992@kroah.com>
 <20101117195843.GA31357@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117195843.GA31357@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 08:58:43PM +0100, Pavel Machek wrote:
> I was hoping you'd comment on the ABI itself, too. It uses 
> 
> echo "foo bar baz" > file
> 
> to enable/disable specific events to be "displayed". More traditional
> interface would be 
> 
> echo disable > file_foo

The main arguments for using the single "mode" file are:
1. that's how it was implemented for OpenWrt, and there's a fair
   amount of userland (web admin tools, etc.) that groks it
2. it's only specifying a set of three possible values -- separate
   files seem like overkill

-- 
Eric Cooper             e c c @ c m u . e d u
