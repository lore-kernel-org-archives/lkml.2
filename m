Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2KSXR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:17:28 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:43558 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab2KSXR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:17:26 -0500
Date: Mon, 19 Nov 2012 16:17:24 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Bill Pemberton <wfp5p@virginia.edu>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 407/493] infiniband: remove use of __devexit
Message-ID: <20121119231724.GA27526@obsidianresearch.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-407-git-send-email-wfp5p@virginia.edu>
 <20121119200921.GD1556@obsidianresearch.com>
 <20121119201938.GA5614@kroah.com>
 <20121119214922.GA5636@obsidianresearch.com>
 <20121119220632.GA1946@kroah.com>
 <20121119224845.GB5636@obsidianresearch.com>
 <20121119230006.GA2523@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119230006.GA2523@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 03:00:06PM -0800, Greg KH wrote:

> I could just leave things alone, with CONFIG_HOTPLUG always enabled, but
> then people will continue to blindly use the __dev* markings, getting it
> wrong at times, but never realizing that they don't do anything anymore.

Well, I was thinking more along the lines of leaving the capability to
remove the __dev* marked functions from the link, as is today,
independent of the other stuff CONFIG_HOTPLUG controls. But reviewing
your comments from the archive makes me think a motivation is misuse
of the __dev* markings..

Thanks for the insight,
Jason
