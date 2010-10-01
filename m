Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab0JASqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:46:17 -0400
Received: from relay1.sgi.com ([192.48.179.29]:44893 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0JASqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:46:16 -0400
Date: Fri, 1 Oct 2010 13:46:15 -0500
From: Robin Holt <holt@sgi.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>, steiner@sgi.com
Subject: Re: [PATCH 3/9] v3 Add section count to memory_block struct
Message-ID: <20101001184615.GJ14064@sgi.com>
References: <4CA62700.7010809@austin.ibm.com>
 <4CA628D0.6030508@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA628D0.6030508@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:30:40PM -0500, Nathan Fontenot wrote:
> Add a section count property to the memory_block struct to track the number
> of memory sections that have been added/removed from a memory block. This
> allows us to know when the last memory section of a memory block has been
> removed so we can remove the memory block.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Reviewed-by: Robin Holt <holt@sgi.com>
