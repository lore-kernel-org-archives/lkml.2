Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab0EGVLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:11:11 -0400
Received: from kroah.org ([198.145.64.141]:50302 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410Ab0EGVLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:11:08 -0400
Date: Fri, 7 May 2010 13:51:18 -0700
From: Greg KH <greg@kroah.com>
To: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix a race in creds_are_invalid() in credentials
 debugging
Message-ID: <20100507205118.GG29461@kroah.com>
References: <20100421092825.19520.48557.stgit@warthog.procyon.org.uk>
 <20100421182301.9EE26B05E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421182301.9EE26B05E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 11:23:01AM -0700, Roland McGrath wrote:
> I think you should submit this for 2.6.3[23]-stable too.

Now queued up.

thanks,

greg k-h
