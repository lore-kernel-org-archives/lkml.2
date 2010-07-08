Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab0GHMdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 08:33:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63803 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab0GHMdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 08:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aZU4yTVrIrYXB95P8h50VZaBUIjzx8UznWDRiwHoK/4fBGMbuSp9LDFUohLwZXnY6j
         x9DIdYCQUCtUcgrzQG5r3pQDRrg8t2B0ehP8nf0EWHl3hnna0gzcBFcd1G4LRvrm6Xw4
         AtjONd3RcPdvpiAA+l37LLsFuwOHy2NXbtcW8=
Message-ID: <4C35C579.3010103@gmail.com>
Date: Thu, 08 Jul 2010 15:32:57 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, Julia Lawall <julia@diku.dk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 16/18] llseek: automatically add .llseek fop
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-17-git-send-email-arnd@arndb.de> <4C35C1F6.70902@gmail.com> <201007081423.34877.arnd@arndb.de>
In-Reply-To: <201007081423.34877.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 03:23 PM, Arnd Bergmann wrote:
> On Thursday 08 July 2010, Boaz Harrosh wrote:
>> On 07/08/2010 12:40 AM, Arnd Bergmann wrote:
>>>
>>> This specific posted version of the patch only
>>> covers first few files in order to avoid
>>> spamming everybody's inbox. I think you still
>>> get the point. The diffstat is complete, and
>>> the full patch is available in the 'llseek'
>>> branch of
>>> git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git
>>>

Yes sorry, I've just seen that you did say.

>> <snip>
>>
>> I only got up to here in the email. (See ml sig below)
>> Do you have this on git or better gitweb somewhere?
> 
> Yes. I was afraid people might reply the patch and quote the
> entire 500kb email without cutting the bits they haven't actually
> read ;-)
> 
> FWIW, you can get the whole patch from
> http://git.kernel.org/?p=linux/kernel/git/arnd/bkl.git;a=patch;h=dc731e01d2a08eb66ae08c226c97aa0cb8cf7b7f
> 

Grate thanks. Ack for the OSD stuff (of course)

> 	Arnd
> 

Boaz

