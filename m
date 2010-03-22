Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab0CVUBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:01:08 -0400
Received: from server109i.appriver.com ([72.32.253.93]:4744 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756079Ab0CVUBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:01:06 -0400
X-Policy: GLOBAL - intcomgrp.com
X-Primary: jkosin@intcomgrp.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: JKosin@intcomgrp.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 216.54.13.100
X-Note-Reverse-DNS: mail.intcomgrp.com
X-Note-WHTLIST: JKosin@intcomgrp.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G179 G180 G181 G182 G186 G187 G198 G285 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
Message-ID: <4BA7CCC5.5020302@intcomgrp.com>
Date: Mon, 22 Mar 2010 16:02:13 -0400
From: James Kosin <jkosin@intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [OT] Style Issues / Concerns
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2010 20:02:13.0632 (UTC) FILETIME=[9078C000:01CAC9FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone,

1) Please forgive me if this is the wrong forum to post this.

2) Please CC me when replying... I'm having list issues right now.

3) Questions / Concerns:

I'm a bit confused as to why there has been a style push to remove
braces {} from the code.

Long ago, code was often missing these braces for exactly the point many
patches are now coming back and reverting back to this antiquated style.

The problem was, and the reason the style changed to include these
braces, was to prevent the common problem of forgetting the braces when
adding another statement to the if or else block of the code.

Example:

if( (x != 0) )
    flag = true;
else
    flag = false;

----

if( (x != 0) )
    flag = true;
    call_something();
else
    flag = false;

----

Before everyone jumps in at once, this is a simple example that will
produce a compiler error about the misplaced else.  However if there are
many if statements above this that may allow the else to be paired up
with it then the code will compile and there will be a serious and very
difficult bug in the code that will take days or months to find.

Why has the style for this changed back?
Does the compiler produce smaller code without the braces {}?

Just my 2-cents,
James Kosin

