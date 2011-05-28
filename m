Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1E1Xrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 19:47:36 -0400
Received: from host171.canaca.com ([67.55.55.225]:54250 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab1E1Xre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 19:47:34 -0400
Message-ID: <8942e3cdf4941912b0855e64939e5939.squirrel@host171.canaca.com>
In-Reply-To: <fd06492f61f15697eb1c8400e29ec7bd.squirrel@host171.canaca.com>
References: <201105282037.22888.michael@m-bauer.org>
    <fd06492f61f15697eb1c8400e29ec7bd.squirrel@host171.canaca.com>
Date: Sat, 28 May 2011 19:47:32 -0400
Subject: Re: [PATCH] hid: Fix Logitech Driving Force Pro wheel
From: simon@mungewell.org
To: "Michael Bauer" <michael@m-bauer.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jiri Kosina" <jkosina@suse.cz>
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 2). The original does Y then 3 others, the replacement does Y + RZ then 1
> other.

OK I missed that you had 'disabled' the first byte value after the hat
switch (which is presumably the combined acc-brake), in preference for the
seperate ACC and Brake.

Is there a reason to prevent the combined acc-brake being reported to the
system?

Surely it would be best to report all options so that the app can decide
which one to use.... I can see that you might want to relabel them for
consistance with Windows.

Do you know what the 4th (and last) byte value is?
Simon


