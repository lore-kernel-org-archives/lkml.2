Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab1JDRgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:36:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60371 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab1JDRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:36:53 -0400
MIME-Version: 1.0
In-Reply-To: <1317749439.29415.251.camel@pasglop>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
 <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
 <1317742838.29415.217.camel@pasglop> <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
 <1317744493.29415.238.camel@pasglop> <CA+55aFyV9uqTt6UHA2wsAdRHHCSAtCSmoO2d3dm62HAo+s75Sg@mail.gmail.com>
 <1317749439.29415.251.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Oct 2011 10:36:32 -0700
X-Google-Sender-Auth: ufP0-8KgkgWdWPknJjX2gixlkJY
Message-ID: <CA+55aFyOcb2y1QVaTNssWFU+nCee8RSs9-wZ-ARnFWcF5MdGSA@mail.gmail.com>
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using "performance" settings
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jon Mason <mason@myri.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 10:30 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Patches 1 and 2 fix it to do what it's supposed to.

Maybe.

Or maybe not.

We just don't the hell know, do we?

And -rc9 is not when we are supposed to make these kinds of changes.

                              Linus
