Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1JBSgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:36:14 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:58600 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753697Ab1JBSgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:36:07 -0400
Message-ID: <4E88AF15.7000503@xenotime.net>
Date: Sun, 02 Oct 2011 11:36:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110020304.28288.rjw@sisk.pl> <4E87B885.50005@zytor.com> <201110021354.57995.rjw@sisk.pl>
In-Reply-To: <201110021354.57995.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/11 04:54, Rafael J. Wysocki wrote:
> On Sunday, October 02, 2011, H. Peter Anvin wrote:
>> On 10/01/2011 06:04 PM, Rafael J. Wysocki wrote:
>>>
>>> OK, I'm taking this as "5 years is fine by us". :-)
>>>
>>> And the recommended procedure for rotating keys seems to be (1) generate
>>> a new key and (2) make as many people as you can sign it before the old
>>> one expires, right?
>>>
>>
>> (3) revoke the old key with a status code of "no longer in use", or just
>> let it expire.
>>
>>>> Some people have decided to opt for an unlimited key, but that
>>>> *requires* that you have a way to revoke the old key, which is why we
>>>> are considering a key revocation escrow service.
>>>
>>> That service will be necessary anyway in case some keys are lost or
>>> compromised.
>>>
>>> I wonder what the procedure of restoring kernel.org access in case one
>>> has lost keys is supposed to be?
>>
>> Get a new key and get it re-signed.
> 
> Hmm.  That doesn't seem very practical if someone doesn't live close
> to any other core kernel developers.
> 
> What number of signatures on the key will be regarded as sufficient?
> 
>> We can work out specific details at KS.
> 
> Well, the KS is going to be busy time this year I suppose. :-)
> 
> What about people who haven't been invited to the KS?

They (we) should start building a web of trust with local key signings.
I'm already working on that in Portland, Oregon.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
