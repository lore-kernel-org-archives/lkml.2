Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab1JAWhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 18:37:06 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:52183 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751309Ab1JAWhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 18:37:01 -0400
Message-ID: <4E87960A.9090104@xenotime.net>
Date: Sat, 01 Oct 2011 15:36:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110012333.55428.rjw@sisk.pl> <4E8793B6.8030405@zytor.com>
In-Reply-To: <4E8793B6.8030405@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/11 15:27, H. Peter Anvin wrote:
> On 10/01/2011 02:33 PM, Rafael J. Wysocki wrote:
>>
>> OK, how long should the new key be valid?
>>
> 
> That is a good question.  At the very least you want it to be valid for
> long enough that you will be able to get enough signatures on a new key
> *before* your old key expires.  As such I would recommend 3-5 years
> depending on how much you trust yourself to keep the key secure.
> 
> Some people have decided to opt for an unlimited key, but that
> *requires* that you have a way to revoke the old key, which is why we
> are considering a key revocation escrow service.

Who needs these privacy keys?  Is it just (git) users of kernel.org?

so people who send patches via email do not need to do this process?
or are we headed into sign-all-patches territory soonish?

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
