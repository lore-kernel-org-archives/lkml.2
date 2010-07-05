Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0GEJS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 05:18:58 -0400
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:37923 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0GEJS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 05:18:57 -0400
Message-ID: <4C31A352.10807@ge.com>
Date: Mon, 05 Jul 2010 10:18:10 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Gustavo Silva <silvagustavosilva@gmail.com>
CC: devel@driverdev.osuosl.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH 4/4] Staging: vme: devices: fix coding style issues in
 vme_user.c
References: <1277594847-19171-1-git-send-email-silvagustavo@users.sourceforge.net> <4C29CF3F.4070500@ge.com>
In-Reply-To: <4C29CF3F.4070500@ge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn Welch wrote:
> Gustavo Silva wrote:
>   
>> This is a patch to the vme_user.c file that fixes up the following
>> issues:
>>
>> WARNING: please, no space before tabs						x 12
>> ERROR: code indent should use tabs where possible				x 15
>> WARNING: braces {} are not necessary for single statement blocks		x  2
>> WARNING: printk() should include KERN_ facility level				x  3
>> ERROR: "foo * bar" should be "foo *bar"						x  1
>> ERROR: space required before the open brace '{'					x  3
>> WARNING: space prohibited between function name and open parenthesis '('	x  1
>> ERROR: spaces required around that '=' (ctx:VxV)				x  2
>> ERROR: spaces required around that '<' (ctx:VxV)				x  2
>> ERROR: space required after that ',' (ctx:VxV)					x  3
>> ERROR: spaces required around that '?' (ctx:VxW)				x  1
>> ERROR: space required before the open parenthesis '('				x  1
>> WARNING: braces {} are not necessary for single statement blocks		x  2
>>
>>   
>>     
>
> This looks very familiar - I'm sure there was a patch already on the
> mailing list doing this, but it has some issues which I don't think were
> ever addressed. This one looks good though.
>
>   
Hmm, seems the earlier patch was fixed up and is now in linux-next, sorry.

Martyn

-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

