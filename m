Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab2CIPTC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:19:02 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49207 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756913Ab2CIPTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:19:00 -0500
X-Sasl-enc: yUWLhLTit5c6hCNr+yzoM6uuFFy3ZtHJMsLlAHFPNSk8 1331306339
Date: Fri, 9 Mar 2012 07:18:57 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 powerpc tree
Message-ID: <20120309151857.GA12578@kroah.com>
References: <20120309164025.dc16cfacaa2ee35cbeea14a8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309164025.dc16cfacaa2ee35cbeea14a8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 04:40:25PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/driver.c between commit fcd6f7620202 ("driver-core: remove
> legacy iSeries hack") from the powerpc tree and commit 9875bb480cc8
> ("Eliminate get_driver() and put_driver()") from the driver-core tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks good to me, thanks for doing this.

greg k-h
