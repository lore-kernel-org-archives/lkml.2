Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1HKIZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:25:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60413 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1HKIZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:25:31 -0400
Date: Thu, 11 Aug 2011 09:25:28 +0100
From: Mel Gorman <mgorman@suse.de>
To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MMTests 0.01
Message-ID: <20110811082528.GA4844@suse.de>
References: <20110804143844.GQ19099@suse.de>
 <1312526302.37390.YahooMailNeo@web162009.mail.bf1.yahoo.com>
 <20110805080133.GS19099@suse.de>
 <1313040359.41174.YahooMailNeo@web162012.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1313040359.41174.YahooMailNeo@web162012.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 10:25:59PM -0700, Pintu Agarwal wrote:
> Dear Mel Gorman,
>  
> I found one problem in MMTests0.01/fraganalysis/Makefile
>  
> When I did "make install" here, I got the following error:
> install: cannot stat `record-buddyinfo': No such file or directory
> make: *** [install-script] Error 1
>  
> I think the following line in makefile need to be corrected:
> #####INSTALL_SCRIPT = pagealloc-extfrag show-buddyinfo slab-intfrag record-buddyinfo
> 
> INSTALL_SCRIPT = pagealloc-extfrag show-buddyinfo slab-intfrag record-extfrag
>  
> I corrected this and it works now.
>  

This is the correct fix. Thanks.

-- 
Mel Gorman
SUSE Labs
