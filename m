Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab1CaSv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:51:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51260 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1CaSvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:51:55 -0400
Date: Thu, 31 Mar 2011 20:51:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        ak@linux.intel.com, david-b@pacbell.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [115/275] OHCI: work around for nVidia shutdown problem
Message-ID: <20110331185153.GM21838@one.firstfloor.org>
References: <20110331060711.GL21838@one.firstfloor.org> <Pine.LNX.4.44L0.1103310948010.2025-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1103310948010.2025-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> For now I think it should be dropped.  There is a fix for the problem
> in that comment, but so far only one person has tested it (in fact,
> only one person has reported having the problem).  For details, see the
> thread starting here:
> 
> 	http://marc.info/?l=linux-kernel&m=130132879827993&w=2
> 
> When the fix is approved and goes into the other stable kernels, then 
> you can merge both patches.
> 

Dropped for now. Thanks.
-Andi
