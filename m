Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032942Ab2CPQ07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:26:59 -0400
Received: from host171.canaca.com ([67.55.55.225]:49099 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740Ab2CPQ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:26:57 -0400
Message-ID: <8107d8a0e50b64dd45dc749da87b2c7b.squirrel@mungewell.org>
In-Reply-To: <20323.25792.171143.809563@quad.stoffel.home>
References: <1b29a178dd288b0f17608b5815ca77a5.squirrel@mungewell.org>
    <20323.25792.171143.809563@quad.stoffel.home>
Date: Fri, 16 Mar 2012 12:26:56 -0400
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


> simon> Also I have a question about the default permissions on the LED
> simon> controls; Is it possible to register LEDs so that users have
> simon> write permission? At present the controls are only accessible
> simon> as root.
>
> udev is the answer here.  You probably want to make it so that the
> LEDs are open to the user logged into the system console or currently
> active Xsession.
>
> John
>

So what would be the best way to achieve this (once the code gets into
kernel)? I mean so that 'Jane Doe' get the LEDs working when she plugs in
her wheel...

At present the patch uses the devices ID's to register the LED's. ie.
--
Mar 14 14:57:35 ubuntu kernel: [ 6462.204185] Registered led device:
0003:046D:C294.0009::RPM1
Mar 14 14:57:35 ubuntu kernel: [ 6462.204251] Registered led device:
0003:046D:C294.0009::RPM2
Mar 14 14:57:35 ubuntu kernel: [ 6462.204301] Registered led device:
0003:046D:C294.0009::RPM3
Mar 14 14:57:35 ubuntu kernel: [ 6462.204354] Registered led device:
0003:046D:C294.0009::RPM4
Mar 14 14:57:35 ubuntu kernel: [ 6462.204402] Registered led device:
0003:046D:C294.0009::RPM5
--

Simon.


