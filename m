Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2DDUSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:18:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34088 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2DDUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:18:23 -0400
Date: Wed, 4 Apr 2012 21:18:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Martin Lucina <martin@lucina.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Implement IP_EVIL socket option (RFC 3514)
Message-ID: <20120404201821.GC6589@ZenIV.linux.org.uk>
References: <1333284791-5363-1-git-send-email-martin@lucina.net>
 <87r4w3nw7n.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4w3nw7n.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 09:17:00PM +0200, Florian Weimer wrote:
> * Martin Lucina:
> 
> > This patch implements the IP_EVIL socket option, allowing user-space
> > applications to set the Security Flag in the IPv4 Header, aka "evil" bit,
> > as defined in RFC 3514.
> 
> I need this to fix a security issue.  Could this be merged for real,
> please?

I would suggest switching away from your RFC1149 link - looks like your mail
took 3 days on the way out...
