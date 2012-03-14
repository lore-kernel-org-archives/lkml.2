Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199Ab2CNBv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:51:26 -0400
Received: from host171.canaca.com ([67.55.55.225]:46644 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965158Ab2CNBvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:51:24 -0400
Message-ID: <46fbb32d8dc2dd368158138eb6c24ca7.squirrel@mungewell.org>
In-Reply-To: <alpine.LNX.2.00.1203132224410.18356@pobox.suse.cz>
References: <ced1eb513cb4134634e89feab0db49ca.squirrel@mungewell.org>
    <alpine.LNX.2.00.1203132224410.18356@pobox.suse.cz>
Date: Tue, 13 Mar 2012 21:51:19 -0400
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
From: simon@mungewell.org
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: simon@mungewell.org, "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
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


>
> Could you please post the full oops?

Just so you don't burn time on this. I think I've got it figured, no
longer Oops (just locks up the machine the second time wheel is
connected).

Going home to try with a real G27...
Simon

