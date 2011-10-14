Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab1JNR6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 13:58:08 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38572 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755726Ab1JNR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 13:58:04 -0400
Message-ID: <4E987829.3080104@xenotime.net>
Date: Fri, 14 Oct 2011 10:58:01 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: linux-next: Tree for Oct 11 (ata/pata_of_platform.c)
References: <20111011201127.455df266dcbffb1d621f8576@canb.auug.org.au> <4E94A920.40503@xenotime.net>
In-Reply-To: <4E94A920.40503@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2011 01:37 PM, Randy Dunlap wrote:
> On 10/11/11 02:11, Stephen Rothwell wrote:
>> Hi all,
>>
>> The linux-next tree is now available from
>> git://github.com/sfrothwell/linux-next.git as a temporary measure while
>> the kernel.org servers are unavailable.
>>
>> It may also turn up on git.kernel.org (depending on the mirroring).  The
>> patch set is still absent, however.
>>
>> Changes since 20111007:
>>
>> Removed tree: ide (at the maintainer's request)
> 
> 
> drivers/ata/pata_of_platform.c:55:13: error: 'NO_IRQ' undeclared (first use in this function)


[adding Author: Anton]

Build error still present in linux-next of 20111014.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
