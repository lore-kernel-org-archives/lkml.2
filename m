Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0JASyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:54:08 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36385 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab0JASyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:54:06 -0400
Date: Fri, 1 Oct 2010 13:54:04 -0500
From: Robin Holt <holt@sgi.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>, steiner@sgi.com
Subject: Re: [PATCH 5/9] v3 rename phys_index properties of memory block
 struct
Message-ID: <20101001185404.GL14064@sgi.com>
References: <4CA62700.7010809@austin.ibm.com>
 <4CA62982.5080900@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA62982.5080900@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:33:38PM -0500, Nathan Fontenot wrote:
> Update the 'phys_index' property of a the memory_block struct to be
> called start_section_nr, and add a end_section_nr property.  The
> data tracked here is the same but the updated naming is more in line
> with what is stored here, namely the first and last section number
> that the memory block spans.
> 
> The names presented to userspace remain the same, phys_index for
> start_section_nr and end_phys_index for end_section_nr, to avoid breaking
> anything in userspace.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Reviewed-by: Robin Holt <holt@sgi.com>
