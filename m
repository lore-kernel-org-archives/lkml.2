Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0DNNkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:40:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab0DNNkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:40:15 -0400
Date: Wed, 14 Apr 2010 15:40:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: add HP Compaq 2710p to 'noloop' table
In-Reply-To: <20100414133801.GA11142@srcf.ucam.org>
Message-ID: <alpine.LNX.2.00.1004141538490.8345@pobox.suse.cz>
References: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz> <20100414123643.GB9242@srcf.ucam.org> <alpine.LNX.2.00.1004141437340.8345@pobox.suse.cz> <20100414135350.3b1643c2@lxorguk.ukuu.org.uk> <20100414125244.GC10075@srcf.ucam.org>
 <20100414143550.75def636@lxorguk.ukuu.org.uk> <20100414133801.GA11142@srcf.ucam.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Matthew Garrett wrote:

> > I think in this case you are in cloud cuckoo land. Windows doesn't 
> > autoprobe all these mouse types, and some years of careful 
> > experimentation seems to indicate the best you can do is select which 
> > devices break without blacklists.
> 
> Blacklists which have to vary based on BIOS version? It's pretty obvious 
> that this doesn't scale.

... and your proposal is?

Ask vendors, who are shipping specialized windows drivers for their mice, 
to be please so kind and always include a linux driver as well, and nuke 
all the probing logic from in-kernel driver?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
