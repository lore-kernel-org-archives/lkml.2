Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2JASAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:00:45 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:37276 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750927Ab2JASAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:00:44 -0400
Message-ID: <1349114440.2577.26.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] net: fix neigh_resolve_output can cause skb_under_panic
From: Ben Hutchings <bhutchings@solarflare.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Ramesh Nagappa <ramesh.nagappa@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michel@digirati.com.br" <michel@digirati.com.br>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Date: Mon, 1 Oct 2012 19:00:40 +0100
In-Reply-To: <20120929005721.GA13335@kroah.com>
References: <CA3E5132752D1F49871ED0FC40D56BBA43ECE2E72D@EUSAACMS0701.eamcs.ericsson.se>
	 <20120928235209.GA11474@kroah.com>
	 <CA3E5132752D1F49871ED0FC40D56BBA43ECE2E743@EUSAACMS0701.eamcs.ericsson.se>
	 <20120929005721.GA13335@kroah.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 17:57 -0700, gregkh@linuxfoundation.org wrote:
[...]
> > > You need a blank line before the first Signed-off-by: line.  
> > > Surely one of the reviewers should have caught this basic thing?
> > 
> > Outlook mangled the patch. I am unable to use git send-email because of
> > a corporate firewall on the build machine.
> 
> Then your patch would also be corrupted, Outlook, and Exchange, can not
> handle patches at all.  Please read Documentation/email_clients.txt for
> more details.
> 
> Also, ask your coworkers who properly submit patches what they do to
> work around your broken email infrastructure.

I successfully send patches using git-imap-send and Evolution talking to
Exchange 2010 through its IMAP and SMTP submission interfaces.  (I think
the previous version worked as well.)  But I would agree that Outlook is
probably hopeless.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

