Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0DNQBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 12:01:35 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:36297 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab0DNQBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 12:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W3teTqukdZOIj6pPugjHigOxPhlPv5H6HFRefBd8o0HZwQ+iGH8wfmHafk1/H+P0R0
         zzb6VGqIVRQUc4/izQP0DZOnp7vQOa5p9A2pWE+C/6e0A8TOBp6asp8ectF843Osz7g1
         BkAZQZCN3yxDH3C2tU0OgjNOS8eUZD1Kq4epQ=
Date: Wed, 14 Apr 2010 09:01:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: add HP Compaq 2710p to 'noloop' table
Message-ID: <20100414160111.GB2450@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz>
 <20100414123643.GB9242@srcf.ucam.org>
 <alpine.LNX.2.00.1004141437340.8345@pobox.suse.cz>
 <20100414135350.3b1643c2@lxorguk.ukuu.org.uk>
 <20100414125244.GC10075@srcf.ucam.org>
 <20100414143550.75def636@lxorguk.ukuu.org.uk>
 <20100414133801.GA11142@srcf.ucam.org>
 <alpine.LNX.2.00.1004141538490.8345@pobox.suse.cz>
 <20100414134321.GA11335@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100414134321.GA11335@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 02:43:21PM +0100, Matthew Garrett wrote:
> On Wed, Apr 14, 2010 at 03:40:14PM +0200, Jiri Kosina wrote:
> 
> > Ask vendors, who are shipping specialized windows drivers for their mice, 
> > to be please so kind and always include a linux driver as well, and nuke 
> > all the probing logic from in-kernel driver?
> 
> Well, in this case we know that there's a synaptics (it's in ACPIPNP) 
> and we know that an internal synaptics places pretty heavy constraints 
> on what else is going to be attached to the machine.
> 

As in... anything? Many boxes still have external PS/2 ports that can
have pretty much any type of mouse attached. Especially those HPs that
have active multiplexor.

-- 
Dmitry
