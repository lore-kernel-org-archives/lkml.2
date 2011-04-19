Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1DSNqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:46:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51309 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1DSNqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:46:52 -0400
Date: Tue, 19 Apr 2011 09:46:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: dtor@mail.ru, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [Xen-devel] [PATCH] [PV Xen] Mouse stuck after save/restore of
 guest.
Message-ID: <20110419134629.GA8590@dumpdata.com>
References: <1302795907-321-1-git-send-email-imammedo@redhat.com>
 <20110414155915.GA23629@dumpdata.com>
 <20110414172649.GA7569@aepfle.de>
 <20110414183804.GB1467@dumpdata.com>
 <20110415093737.GA15122@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415093737.GA15122@aepfle.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Was wondering if you are OK pushing this for 2.6.39-rc3 or whether you are OK
> > with me doing. It fixes a regression introduced by the last hunk of 
> > 5ea5254aa0ad269cfbd2875c973ef25ab5b5e9db
> 
> Looking through my backlog, I noticed that the patch went also to
> stable@kernel.org and is now in various trees already.
> So please forward this revert also to stable@suse.de

OK. The upstream git commit is c36b58e8a9112017c2bcc322cc98e71241814303.

Which stable tree did it go through? 2.6.38 only I presume?

