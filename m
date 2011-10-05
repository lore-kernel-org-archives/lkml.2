Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934965Ab1JEQ0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:26:09 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:37597 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934476Ab1JEQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:26:06 -0400
Date: Wed, 5 Oct 2011 09:26:00 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jon Mason <mason@myri.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using
 "performance" settings
Message-ID: <20111005092600.36d505b2@jbarnes-desktop>
In-Reply-To: <CA+55aFwoeC+X=XWWJ7HFUfz6tZmJW6PMmkGcRM5otLbyGt587Q@mail.gmail.com>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
	<CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
	<1317742838.29415.217.camel@pasglop>
	<CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
	<1317744493.29415.238.camel@pasglop>
	<CA+55aFyV9uqTt6UHA2wsAdRHHCSAtCSmoO2d3dm62HAo+s75Sg@mail.gmail.com>
	<1317749439.29415.251.camel@pasglop>
	<CA+55aFyOcb2y1QVaTNssWFU+nCee8RSs9-wZ-ARnFWcF5MdGSA@mail.gmail.com>
	<1317798113.29415.270.camel@pasglop>
	<CA+55aFwoeC+X=XWWJ7HFUfz6tZmJW6PMmkGcRM5otLbyGt587Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011 07:49:24 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Oct 5, 2011 at 12:01 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> >> We just don't the hell know, do we?
> >
> > Well, we do with some confidence :-) Or rather what we do know is what
> > you have today in your tree is broken.
> 
> You're missing the point.
> 
> Repeat after me: late -rc series is not when we test these kinds of things.

Yeah I think Ben just wants the convenience of having the non-default
code paths fixed when 3.1 comes out; but I agree we shouldn't be poking
around at all at this point.

Hopefully I'll get my kernel.org tree back up and running this week so
I can queue up the various fixes for the merge window.  I'll do another
scan and ask people to send directly to you for the 2 or 3 things we
still have open for 3.1.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
