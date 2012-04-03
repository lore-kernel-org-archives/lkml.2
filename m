Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2DCCPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:15:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40859 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab2DCCO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:14:59 -0400
Date: Tue, 3 Apr 2012 04:14:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff: Use Private Data
In-Reply-To: <44acbf3ff0b6aa62eab2831ee6ecea80.squirrel@mungewell.org>
Message-ID: <alpine.LNX.2.00.1204030413550.16928@pobox.suse.cz>
References: <a4e40aa5c43be934d83240849aa25f3b.squirrel@mungewell.org>    <1333378444-3117-1-git-send-email-simon@mungewell.org>    <4F79D486.5090605@suse.cz> <44acbf3ff0b6aa62eab2831ee6ecea80.squirrel@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2012, simon@mungewell.org wrote:

> >> +	struct lg4ff_device_entry *uninitialized_var(entry);
> >> +	struct lg_drv_data *uninitialized_var(drv_data);
> >
> > You don't need uninitialized_var bloat anymroe, right?
> 
> I guess I don't fully understand the 'unitialized_var()' macro, and was
> just following the previous uses in the code.
> 
> Google'ing doesn't really help either. Is there a definitive guide as when
> to use and not?

As Jiri Slaby already explained, it's rather a hack to shut up gcc in 
cases in which it gets the unused warning wrong.

But even that is considered controversial by some people ... 

-- 
Jiri Kosina
SUSE Labs
