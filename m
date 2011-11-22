Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab1KVRYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:24:09 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:60988 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab1KVRYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:24:07 -0500
Message-ID: <1321982633.1753.12.camel@x61.thuisdomein>
Subject: Re: [PATCH] [TRIVIAL] sound: Kconfig: drop unknown symbol
 ARCH_CLPS7500
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 22 Nov 2011 18:23:53 +0100
In-Reply-To: <alpine.LNX.2.00.1111221813320.28728@pobox.suse.cz>
References: <1321963622.18752.1.camel@x61.thuisdomein>
	 <alpine.LNX.2.00.1111221813320.28728@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 18:14 +0100, Jiri Kosina wrote:
> While you are at it, there is one more reference to this symbol (in 
> comments) in drivers/net/ethernet/cirrus/cs89x0.c

Yes, in a changelog entry which I didn't want to touch yet. Should
changelogs, like that one, be dropped as soon as we're doing something
related? Or should the changelog cleanup be a separate, treewide (and
rather daunting!) task?


Paul Bolle

