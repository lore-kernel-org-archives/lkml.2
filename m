Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933110Ab1JDRlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:41:13 -0400
Received: from kanga.kvack.org ([205.233.56.17]:40259 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791Ab1JDRlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:41:12 -0400
Date: Tue, 4 Oct 2011 13:41:11 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jon Mason <mason@myri.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance" settings
Message-ID: <20111004174111.GI19130@kvack.org>
References: <1317653420-21404-3-git-send-email-mason@myri.com> <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com> <1317742838.29415.217.camel@pasglop> <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com> <1317744493.29415.238.camel@pasglop> <CA+55aFyV9uqTt6UHA2wsAdRHHCSAtCSmoO2d3dm62HAo+s75Sg@mail.gmail.com> <1317749439.29415.251.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317749439.29415.251.camel@pasglop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 07:30:39PM +0200, Benjamin Herrenschmidt wrote:
> Well, thing is, you -already- have the whole "performance" option which
> is what we are 'arguing' about upstream. Except that the implementation
> of it that you have in your tree now has very nasty bugs (ie it doesn't
> do what it's supposed to and really doesn't work).
> 
> Patches 1 and 2 fix it to do what it's supposed to.

I'll agree with benh for now since, yes, the performance option is 
completely broken in just blindly applying settings right now.  It should 
be revisted and made so that a safe performance setting is supported in 
the future (possibly via suggestions from arch-specific quirks), since 
having to configure this makes little sense for the vast majority of 
users.  Applying 3/3 first would also make the most sense.

		-ben

