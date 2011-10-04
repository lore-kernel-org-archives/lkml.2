Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1JDPtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:49:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33263 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1JDPtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:49:17 -0400
MIME-Version: 1.0
In-Reply-To: <1317742838.29415.217.camel@pasglop>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
 <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com> <1317742838.29415.217.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Oct 2011 08:48:55 -0700
X-Google-Sender-Auth: o_A9GQ2FDA2xlhDZyHfjLGTPvQo
Message-ID: <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
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

On Tue, Oct 4, 2011 at 8:40 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> Hopefully most of these patches only affect the "performance" setting
> which is no longer the default.
>
> But yes, more reviews are always welcome.

Well, bcrl argues that patches 1-2 of 3 are actively wrong.

Quite frankly, my gut feel is that this late in the game, the only
patch I should apply is 3/3, and even that I wonder about. But that
seems to *really* disable all the games we do, and that all seem to be
questionable.

Comments? Please? I'm going to do an -rc9 today, and after that I'll
be travelling a lot, so..

                       Linus
