Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab0CSD7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 23:59:11 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43328 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0CSD7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 23:59:10 -0400
Date: Fri, 19 Mar 2010 12:58:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "J.H." <warthog9@kernel.org>
Cc: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] [KORG] Availability of SSL on kernel.org
Message-ID: <20100319035806.GB25308@linux-sh.org>
References: <4BA2CFB7.7070108@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2CFB7.7070108@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 06:13:27PM -0700, J.H. wrote:
> Services that are now by default using SSL:
> 
>     * Bugzilla
>     * Wikis
>     * Account Requests
>     * Patchwork
> 
>     These are using an HTTP redirect so you should need to do anything
>     for these to just work.
> 
This seems to have at least broken pwclient for me, although perhaps I'm
doing something wrong. Any of the pwclient operations as of this morning
bail out with:

xmlrpclib.ProtocolError: <ProtocolError for patchwork.kernel.org/xmlrpc/: 302 Found>

If I change the pwclientrc url to https:// instead then at least pwclient
list and get work, but update bombs out in the same way. I checked the
pwclientrc from the project info pages incase there was an update, but
those don't seem to have changed in format at all.

The web interface continues to work fine.
