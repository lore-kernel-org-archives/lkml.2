Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab1D0Q1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:27:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:48077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759271Ab1D0Q1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:27:01 -0400
Date: Wed, 27 Apr 2011 09:26:59 -0700
From: Tony Jones <tonyj@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: PATCH [1/1]: audit: acquire creds selectively to reduce atomic
 op overhead
Message-ID: <20110427162659.GA16299@suse.de>
References: <1300211077.3748.2.camel@localhost.localdomain>
 <20110310202516.GA16122@suse.de>
 <20110307210656.GA1750@suse.de>
 <18893.1299607373@redhat.com>
 <29980.1299861232@redhat.com>
 <20110315173810.GA12775@suse.de>
 <21526.1300219877@redhat.com>
 <20110317181159.GA31948@suse.de>
 <1300715854.2744.0.camel@unknown001a4b0c2895>
 <alpine.LRH.2.00.1104271511240.6728@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1104271511240.6728@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 03:12:23PM +0200, Jiri Kosina wrote:
> I don't see the patch in linux-next as of today. As it has been acked by 
> subsystem maintainer, I have picked it up into my tree ("retransmission 
> mode").
> 
> If anyone has any objections, please let me know. Thanks.

I spoke to Eric about this 10 days ago and he was going to create an audit
tree for the next window. 

Tony
