Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0GaJjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 05:39:05 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:40627 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0GaJjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 05:39:01 -0400
Message-ID: <4C53EF30.5020303@davidnewall.com>
Date: Sat, 31 Jul 2010 19:08:56 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-kernel@vger.kernel.org, "doug.dahlby" <Doug.Dahlby@atheros.com>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Using unsigned int for loop counters - better performance for
 	Architectures - urban hacker legend?
References: <AANLkTi=AuFBwT5AjRdjrkbe3=5d36TNr4Cp=r0VnEogH@mail.gmail.com>
In-Reply-To: <AANLkTi=AuFBwT5AjRdjrkbe3=5d36TNr4Cp=r0VnEogH@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know about unsigned int; but looping down to zero should be 
faster on many architectures, as they automatically test for zero (or 
negative) on decrement.  Counting up requires an additional test.
