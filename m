Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0LHNdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 08:33:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:36055 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab0LHNdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 08:33:16 -0500
Date: Wed, 8 Dec 2010 14:33:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] sysfs: Introducing binary attributes for struct
 class
In-Reply-To: <1290801449.18750.162.camel@neuromancer>
Message-ID: <alpine.LNX.2.00.1012081432230.14806@pobox.suse.cz>
References: <1290801449.18750.162.camel@neuromancer>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010, Stefan Achatz wrote:

> Added dev_bin_attrs to struct class similar to existing dev_attrs.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>

Greg, just to make sure (as you have stated your Ack in a thread belonging 
to different thread) -- I can add your Acked-by: to this patch and take it 
through my tree with the rest of the roccat patchset, is that correct?

Thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
