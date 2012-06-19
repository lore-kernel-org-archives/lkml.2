Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab2FSURp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 16:17:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:50726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab2FSURo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 16:17:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Date: Tue, 19 Jun 2012 22:23:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Borislav Petkov <bp@alien8.de>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com> <20120619142111.GA4151@x1.osrc.amd.com> <eac3880d-fee8-4006-ba92-8ab55f8d3ab2@email.android.com>
In-Reply-To: <eac3880d-fee8-4006-ba92-8ab55f8d3ab2@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206192223.07326.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 19, 2012, Bojan Smojver wrote:
> Borislav Petkov <bp@alien8.de> wrote:
> 
> >which, on the whole, is nice and compact and still contains the whole
> >info.
> 
> Yeah, that was the deal with the dots too. But, Rafael suggested we do
> lines (and I see his point). This way any other lines printed in the meantime
> (I have seen that happen) will also print properly. Ditto that last line - 100%
> is still not quite finished. :-)

Exactly.

I'd use a slightly different status line, though.  What about:

"PM: Image saving progress: %d%%"

Then, if something is printed in between those lines, it'll still be clear
what they mean.

Thanks,
Rafael
