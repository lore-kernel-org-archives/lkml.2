Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1LFVio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 16:38:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab1LFVin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 16:38:43 -0500
Date: Tue, 6 Dec 2011 16:38:10 -0500
From: Jeff Layton <jlayton@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Belisko Marek <marek.belisko@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: CIFS mount: 3.2.0-rc3 suspend crash
Message-ID: <20111206163810.24663e3f@tlielax.poochiereds.net>
In-Reply-To: <201112062233.50317.rjw@sisk.pl>
References: <4ED56C12.1040708@gmail.com>
	<4ED5C047.6040500@linux.vnet.ibm.com>
	<20111130062502.68d9db59@tlielax.poochiereds.net>
	<201112062233.50317.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011 22:33:50 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday, November 30, 2011, Jeff Layton wrote:
> > On Wed, 30 Nov 2011 11:03:59 +0530
> > "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
> [...]
> > 
> > cifs: attempt to freeze while looping on a receive attempt
> > 
> > In the recent overhaul of the demultiplex thread receive path, we
> > neglected to ensure that we attempt to freeze on each pass through the
> > loop.
> > 
> > Reported-by: Woody Suwalski <terraluna977@gmail.com>
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> I suppose this patch is going to go through the CIFS tree?
> 

Yes, Steve said he would push it Linus...

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
