Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2LFJTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:19:46 -0500
Received: from multi.imgtec.com ([194.200.65.239]:54513 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab2LFJTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:19:44 -0500
Message-ID: <50C0632C.9000206@imgtec.com>
Date: Thu, 6 Dec 2012 09:19:40 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: [PATCH v2 00/44] Meta Linux Kernel Port
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <20121205171131.GV4939@ZenIV.linux.org.uk>
In-Reply-To: <20121205171131.GV4939@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2012_12_06_09_19_41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/12 17:11, Al Viro wrote:
> On Wed, Dec 05, 2012 at 04:08:18PM +0000, James Hogan wrote:
> 
>> other work not included:
>> * switch to generic kernel_{thread,execve} (will be posted separately to
>>   aid review)
> 
>> other changes:
> ...
>> * switch to generic sys_execve
> 
> ... which should've broken your kernel_execve().
> 

Hi Al,

Yes, you're right. I should have taken more care separating that patch
out. Sorry about that.

Cheers
James

