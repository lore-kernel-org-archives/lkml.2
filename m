Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab0HSHln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 03:41:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab0HSHlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 03:41:42 -0400
Date: Thu, 19 Aug 2010 09:41:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Heinz Diehl <htd@fritha.org>
Cc: Alan Ott <alan@signal11.us>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
In-Reply-To: <20100812164035.GB6761@fritha.org>
Message-ID: <alpine.LNX.2.00.1008190941120.1019@pobox.suse.cz>
References: <alpine.LNX.2.00.1008121108540.2702@pobox.suse.cz> <20100812091659.GA1591@arch.tripp.de> <alpine.LNX.2.00.1008121148100.2702@pobox.suse.cz> <20100812113624.GB1591@arch.tripp.de> <20100812114513.GA1584@arch.tripp.de> <20100812115657.GA1611@arch.tripp.de>
 <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz> <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz> <20100812130411.GA1626@arch.tripp.de> <4C63F285.8070801@signal11.us> <20100812164035.GB6761@fritha.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Aug 2010, Heinz Diehl wrote:

> > >>Could please those of you, who are able to reproduce the problem, verify
> > >>whether the patch below (completely untested) makes everything behave
> > >>again? Thanks.
> 
> > >Yes, everything behaves again. Thanks Jiri.
>  
> > Seconded. Works good. Thanks for your support Jiri.
> 
> Thirded! This fixes the warning here.

The fix is now in Linus' tree, and thus will be in -rc2. Thanks everyone 
for testing.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
