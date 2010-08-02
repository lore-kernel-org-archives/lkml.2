Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0HBKQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 06:16:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0HBKQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 06:16:12 -0400
Message-ID: <4C569BCA.3050603@ontolinux.com>
Date: Mon, 02 Aug 2010 12:19:54 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Preview of changes to the Security susbystem for 2.6.36
References: <alpine.LRH.2.00.1007301852110.14431@tundra.namei.org> <alpine.LRH.2.00.1008021216520.31941@tundra.namei.org> <20100802063224.GR3948@outflux.net> <alpine.LRH.2.00.1008021639230.32603@tundra.namei.org> <20100802065746.GS3948@outflux.net>
In-Reply-To: <20100802065746.GS3948@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:TNki3mzCC6pqgvgLrKm9KbSSpeWYwxYDBDnTMElFB7v
 4CKz5fgZmkr+IEzin26rKxu9C3XLeQJ5F6uNoXUd759okXSl/z
 QLe/k8fQcIKTFM3DWZr8oZ+l93PniD96Q5qoRkVzWDN03mu5tg
 oMSArB6nF1+osqKVQpbj/XBlFjsQoxxvj7f8I+La+hV+DJekQs
 9wBoXTl5S7wBOm/QEqpIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aloha James, Aloha Kees;
Ont the 02.08.2010 08:57,  Kees Cook wrote:
> On Mon, Aug 02, 2010 at 04:41:08PM +1000, James Morris wrote:
>    
>> On Sun, 1 Aug 2010, Kees Cook wrote:
>>      
>>> Well, at least I'll have something for my summit presentation again.
>>>
>>> On the other hand, it's rather hard for me to defend against a private NAK.
>>>        

A private NAK against a company's developer's OK
Where is the difference private and company? I thought that it doesn't 
matter who and what a developer is, and where she/he comes from.

>> It's the same nak as before -- I concluded there was consensus on the
>> lists, but was wrong.
>>      

The opinion as well as the NAK by Christoph was discussed and supported 
by other developers.

>>> James, will it stay in security-testing for .37 hopefully?
>>>        
>> Not with this approach, I'd imagine.
>>      

Yes, because it supports as an experiment the development of the LSM 
architecture in general.

> I'm sorry to appear dense, but the most recent NAK from Christoph was
> here[1], which was for a patch to Yama that is not in security-testing
> yet. Prior to that, all I could find was this[2] which explicitly asked
> me to put stuff in a special LSM.
>    

That is not quite right.
It is correct that this special Yama LSM was accepted so far. The 
inclusion into mainline was not an issue at that time.
But we discussed as well that the problem of chaining of small or large 
LSMs is not an argument for the existence of the Yama LSM, and that the 
LSM architecture should be developed further so that all of the 
functionalities of other securtiy packages without an LSM can be 
integrated as a whole by a new version of the LSM system in the future 
and not by ripping them of like it was done with the Yama LSM [3].
You can see these objections [3] as a second NAK, but now from a 
company's developer (I haven't said this before, because I'm not a hard 
core kernel developer).

> I really would like to see it in mainline, but next steps are not clear.
>
> -Kees
>
> [1] http://lkml.org/lkml/2010/6/30/31
> [2] http://lkml.org/lkml/2010/6/1/78
>
>    

[3] http://lkml.org/lkml/2010/6/30/64

Have fun in the sun
Christian Stroetmann
