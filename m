Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0CVUcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:32:51 -0400
Received: from server109.appriver.com ([72.32.253.84]:1800 "EHLO
	server109.appriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab0CVUcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:32:48 -0400
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
Message-ID: <4BA7D433.1050109@intcomgrp.com>
Date: Mon, 22 Mar 2010 16:33:55 -0400
From: James Kosin <jkosin@intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [OT] Style Issues / Concerns
References: <4BA7CCC5.5020302@intcomgrp.com> <87wrx45d4d.fsf@basil.nowhere.org>
In-Reply-To: <87wrx45d4d.fsf@basil.nowhere.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Mar 2010 20:33:55.0699 (UTC) FILETIME=[FE312430:01CAC9FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/2010 4:13 PM, Andi Kleen wrote:
> James Kosin <jkosin@intcomgrp.com> writes:
>   
>> Before everyone jumps in at once, this is a simple example that will
>> produce a compiler error about the misplaced else.  However if there are
>> many if statements above this that may allow the else to be paired up
>> with it then the code will compile and there will be a serious and very
>> difficult bug in the code that will take days or months to find.
>>     
> Modern editors with auto indent mode makes it actually very easy
> to find such bugs.
>
> Also checkpatch.pl checks for it now I believe.
>   
Thanks for the speedy reply.

Does this mean developers need to install X or some graphical
environment now to develop the kernel?
If so what options are available to those that don't want a graphical
environment to develop under?

Sorry if I'm old fashioned.

Thanks again,
James K.
