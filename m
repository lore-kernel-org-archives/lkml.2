Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2FSWfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 18:35:50 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:32998 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2FSWft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 18:35:49 -0400
Message-ID: <1340145346.29338.13.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jun 2012 08:35:46 +1000
In-Reply-To: <201206182328.19811.rjw@sisk.pl>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com>
	 <201206182229.32055.rjw@sisk.pl>
	 <8c993882-5949-471d-a15c-0c91d3d2deb9@email.android.com>
	 <201206182328.19811.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.2 (3.4.2-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 23:28 +0200, Rafael J. Wysocki wrote:
> > PS. Yeah, the current printout with \b is a hack and I do not
> particularly
> > like it either. Proper way would be with plymouth or something like
> that, but
> > I got no joy with that on that list. One day, maybe...
> 
> I'm not sure what you mean?

Sorry, I never answered your question here.

Plymouth (and other such software) provides graphical boot support. We
should be sending stuff to it to display nice, graphical
hibernation/thaw progress indicator. An exercise for the future,
perhaps.

-- 
Bojan

