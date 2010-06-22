Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0FVVRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:17:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40065
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755856Ab0FVVRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:17:09 -0400
Date: Tue, 22 Jun 2010 14:17:21 -0700 (PDT)
Message-Id: <20100622.141721.242120880.davem@davemloft.net>
To: sam@ravnborg.org
Cc: vst@vlnb.net, sparclinux@vger.kernel.org, simone.ricci@gmail.com,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Nick.Couchman@seakr.com, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: Error "Unknown relocation: 36" on module load on Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100622193530.GA26041@merkur.ravnborg.org>
References: <20100616.133540.189696272.davem@davemloft.net>
	<4C210A07.80906@vlnb.net>
	<20100622193530.GA26041@merkur.ravnborg.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Tue, 22 Jun 2010 21:35:30 +0200

> Most of your Makefile looks fine - I guess we need to find the bug
> in the build environmnet and not in the Makefile.

Sam, note that these guys are working with 2.6.26 or some
ancient kernel like that :-/
