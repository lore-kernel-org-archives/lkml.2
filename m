Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab2KXHwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 02:52:45 -0500
Received: from science.horizon.com ([71.41.210.146]:52757 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751884Ab2KXHwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 02:52:44 -0500
Date: 24 Nov 2012 02:52:43 -0500
Message-ID: <20121124075243.28390.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, mgorman@suse.de
Subject: Re: 3.7-rc6 soft lockup in kswapd0
Cc: dave@linux.vnet.ibm.com, jack@suse.cz, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20121123100222.21774.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> tl;dr: Have installed Dave Hansen's patch as requested, rebooted.
>        Now it's a matter of waiting for lockup...

Well, the machine locked up again; it looks like Dave Hansen's patch
isn't the whie story.  Too bad I'm away from the office and can't get
at the console right now.

I'll get the extra information when I have the chance.
