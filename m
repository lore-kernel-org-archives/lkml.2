Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0K1WyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 17:54:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:60019 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097Ab0K1WyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 17:54:11 -0500
Subject: Re: [PATCH 02/11] x86: Add device tree support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20101128134907.GA30784@www.tglx.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-3-git-send-email-bigeasy@linutronix.de>
	 <1290807736.32570.143.camel@pasglop>  <20101128134907.GA30784@www.tglx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 09:28:48 +1100
Message-ID: <1290983328.32570.184.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-28 at 14:49 +0100, Sebastian Andrzej Siewior wrote:
> 
> >(*) That brings a separate topic we shall discuss: A consistent way for
> >versionning the device-tree would be really useful.
> This isn't a problem unless you move nodes or deprecate them, right? Or
> do you think about another reason to versionning the device-tree?.

Move nodes, deprecate them, yes, but also maybe fix bugs/typos etc... 

For most of these, of course, fixup code can figure things out without a
version. The version has a couple of (minor) advantages, such as being
something easier to get into a bug report rather than the whole tree,
for distro who may want to manage a "pool" of these, or maybe a
"generic" way to provide dtb "overrides" ...

Ben.


