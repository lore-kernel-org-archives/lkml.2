Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031046Ab2CVRAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:00:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55701 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031000Ab2CVRAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:00:20 -0400
Message-ID: <4F6B5A9F.2040604@suse.cz>
Date: Thu, 22 Mar 2012 18:00:15 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120320 Thunderbird/13.0a2
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Phil Carmody <ext-phil.2.carmody@nokia.com>, apw@canonical.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in
 function declarations
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com>            <4F6B51C9.6010904@suse.cz> <4517.1332434943@turing-police.cc.vt.edu> <4F6B598A.7090909@suse.cz>
In-Reply-To: <4F6B598A.7090909@suse.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 05:55 PM, Jiri Slaby wrote:
> On 03/22/2012 05:49 PM, Valdis.Kletnieks@vt.edu wrote:
>> On Thu, 22 Mar 2012 17:22:33 +0100, Jiri Slaby said:
>>> That explanation is not fully correct. C99 explicitly says
>>> (6.7.5.3.14): An identifier list declares only the identifiers of
>>> the parameters of the function. An empty list in a function
>>> declarator that is part of a definition of that function
>>> specifies that the function has no parameters. The empty list in
>>> a function declarator that is not part of a definition of that
>>> function specifies that no information about the number or types
>>> of the parameters is supplied.
>>>
>>> So what you are trying to force here holds only for (forward) 
>>> declarations. Not for functions with definitions (bodies). Is
>>> checkpatch capable to differ between those?
>>
>> The fact that 'int foo() { /*whatever*/ }' with an empty parameter
>> list is *legal* doesn't mean that we can't collectively put our
>> foot down and say "This is too ugly to live in our source tree".

And I pointed that out because I didn't want people to start converting
such uses in batches now.

thanks,
-- js suse labs


