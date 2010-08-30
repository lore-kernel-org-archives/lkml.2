Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0H3S6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 14:58:44 -0400
Received: from tex.lwn.net ([70.33.254.29]:54863 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab0H3S6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 14:58:43 -0400
Date: Mon, 30 Aug 2010 12:59:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Eric Anholt" <eric@anholt.net>
Subject: Re: [Bug #17151] i915: 2.6.36-rc2 hoses my Intel display
Message-ID: <20100830125941.6549eb4d@tpl.lwn.net>
In-Reply-To: <4AUWBNzTkbD.A._vH.yFueMB@chimera>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	<4AUWBNzTkbD.A._vH.yFueMB@chimera>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 00:36:36 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> The following bug entry is on the current list of known regressions
> from 2.6.35.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17151

Yes, it was still definitely not working as of just a little prior to
-rc3. 

jon
