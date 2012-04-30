Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2D3Ifs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:35:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab2D3Ifq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:35:46 -0400
Date: Mon, 30 Apr 2012 10:35:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] hid: Introduce device groups
In-Reply-To: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
Message-ID: <alpine.LNX.2.00.1204301032410.1856@pobox.suse.cz>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012, Henrik Rydberg wrote:

> Hi Jiri,
> 
> Here is the third version of the extension to the device-driver
> matching mechanism. AFAICT, there are no outstanding issues. I think
> we are getting close. :-)

I think so, and overall I like the aproach and the implementation. Thanks!

Just got the stacktrace on [1] though when running kernel with this 
patchset. The trace popped during shutdown, and the machine froze 
completely; I didn't have any kind of external console connected, so 
unfortunately I don't have the beginning of the whole thing.

I haven't been able to reproduce it so far. This was after several 
"parallel" plug/remove cycles of multiple HID devices driven by multiple 
different drivers.

I haven't performed any analysis what this might be yet.

[1] http://www.jikos.cz/jikos/junk/autoloading-trace.jpg


-- 
Jiri Kosina
SUSE Labs
