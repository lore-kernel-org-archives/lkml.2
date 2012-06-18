Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2FRVXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 17:23:01 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48963 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab2FRVXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 17:23:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Date: Mon, 18 Jun 2012 23:28:19 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Borislav Petkov <bp@alien8.de>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com> <201206182229.32055.rjw@sisk.pl> <8c993882-5949-471d-a15c-0c91d3d2deb9@email.android.com>
In-Reply-To: <8c993882-5949-471d-a15c-0c91d3d2deb9@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206182328.19811.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 18, 2012, Bojan Smojver wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> >So, I think printing a status line every 10% would be fine.
> 
> My patch prints a dot every 10%, which is not on a separate line.
> Did you want me print a full line instead or are you saying dots are fine?

I think I'd prefer a full status line every 10%.  Or even maybe every 20%.

> PS. Yeah, the current printout with \b is a hack and I do not particularly
> like it either. Proper way would be with plymouth or something like that, but
> I got no joy with that on that list. One day, maybe...

I'm not sure what you mean?
