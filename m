Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2GCPDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:03:11 -0400
Received: from mail.vyatta.com ([76.74.103.46]:52456 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2GCPDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:03:09 -0400
Date: Tue, 03 Jul 2012 08:03:09 -0700 (PDT)
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, apw@canonical.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, KY Srinivasan <kys@microsoft.com>
Subject: Re: [PATCH 00/13] drivers: hv: kvp
Message-ID: <642e6af6-fc6b-4c54-a4a6-f5bdd38512c7@tahiti.vyatta.com>
In-Reply-To: <20120703132049.GA10663@aepfle.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [50.53.80.93]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - GC21 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Mon, Jul 02, KY Srinivasan wrote:
> 
> > While I toyed with your proposal, I feel it just pushes the problem
> > out of the daemon code - we would still need to write distro
> > specific
> > scripts. If this approach is something that everybody is
> > comfortable
> > with, I can take a stab at implementing that.
> 
> Until NetworkManager is feature complete and until every distro is
> using
> NetworkManager per default the kvp_daemon needs distro specific code
> to
> get and set network related settings.
> Doing it with an external script will simplify debugging and changes
> to
> the code.

Although,  Network Manager is a good tool for what it does;
it is not appropriate for every distro. It is overkill
in embedded systems, and it's GUI dependency makes it unmanageable
on servers. 
