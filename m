Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161816Ab2CPQiy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:38:54 -0400
Received: from host171.canaca.com ([67.55.55.225]:36722 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031294Ab2CPQiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:38:51 -0400
Message-ID: <f04eb1355e17dbe4ce7bbdd47da0056e.squirrel@mungewell.org>
In-Reply-To: <20323.25792.171143.809563@quad.stoffel.home>
References: <1b29a178dd288b0f17608b5815ca77a5.squirrel@mungewell.org>
    <20323.25792.171143.809563@quad.stoffel.home>
Date: Fri, 16 Mar 2012 12:38:50 -0400
Subject: Re: Building BarGraph with LED subsystem
From: simon@mungewell.org
To: "John Stoffel" <john@stoffel.org>
Cc: simon@mungewell.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
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


> While making the kernel more complex... esp for a feature which is of
> such limited use.

Is the concept of a bargraph of LEDs really a 'limited use'? I can think
of several uses... I mean isn't flashing or a heart beat just as limited
;-)


> Do it all in userland, it's easier, you can use
> floating point math, etc.  And to test changes, you don't have to
> recompile a module and unload/reload it, etc.

For my application a user-land stub would do math to work out threshold
values and push current value (in the right format) into the LED
subsystem.

Once kernel framework is provided it should not need re-compilation on a
case by case basis.

Simon

