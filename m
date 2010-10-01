Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0JASkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:40:20 -0400
Received: from relay1.sgi.com ([192.48.179.29]:49131 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab0JASkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:40:19 -0400
Date: Fri, 1 Oct 2010 13:40:14 -0500
From: Robin Holt <holt@sgi.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>, steiner@sgi.com
Subject: Re: [PATCH 1/9] v3 Move find_memory_block routine
Message-ID: <20101001184014.GH14064@sgi.com>
References: <4CA62700.7010809@austin.ibm.com>
 <4CA62857.4030803@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA62857.4030803@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:28:39PM -0500, Nathan Fontenot wrote:
> Move the find_memory_block() routine up to avoid needing a forward
> declaration in subsequent patches.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Reviewed-by: Robin Holt <holt@sgi.com>
