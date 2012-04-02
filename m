Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2DBRBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:01:34 -0400
Received: from host171.canaca.com ([67.55.55.225]:39155 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2DBRBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:01:32 -0400
Message-ID: <44acbf3ff0b6aa62eab2831ee6ecea80.squirrel@mungewell.org>
In-Reply-To: <4F79D486.5090605@suse.cz>
References: <a4e40aa5c43be934d83240849aa25f3b.squirrel@mungewell.org>
    <1333378444-3117-1-git-send-email-simon@mungewell.org>
    <4F79D486.5090605@suse.cz>
Date: Mon, 2 Apr 2012 13:01:30 -0400
Subject: Re: [PATCH 1/2] HID: hid-lg4ff: Use Private Data
From: simon@mungewell.org
To: "Jiri Slaby" <jslaby@suse.cz>
Cc: "Simon Wood" <simon@mungewell.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Jiri Kosina" <jkosina@suse.cz>,
        "Michael Bauer" <michael@m-bauer.org>,
        "Michal Maly" <madcatxster@gmail.com>
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


>> +	struct lg4ff_device_entry *uninitialized_var(entry);
>> +	struct lg_drv_data *uninitialized_var(drv_data);
>
> You don't need uninitialized_var bloat anymroe, right?

I guess I don't fully understand the 'unitialized_var()' macro, and was
just following the previous uses in the code.

Google'ing doesn't really help either. Is there a definitive guide as when
to use and not?

Simon

