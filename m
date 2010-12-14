Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab0LNRrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:47:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:60804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932394Ab0LNRrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:47:35 -0500
Message-ID: <4D07AD80.7030903@kernel.org>
Date: Tue, 14 Dec 2010 18:46:40 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCHSET] ptrace,signal: sane interaction between ptrace and
 job control signals, take#2
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <20101214173600.GA16253@redhat.com>
In-Reply-To: <20101214173600.GA16253@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 17:46:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/14/2010 06:36 PM, Oleg Nesterov wrote:
> On 12/06, Tejun Heo wrote:
>>
>> This is the second attempt at cleaning up ptrace and signal behaviors,
> 
> Tejun, I am really, really sorry for the huge delay.
> 
> I will _try_ very much to read this on Friday. If nothing else,
> I am very interested to understand these changes in details.

No need to be sorry at all.  It's not like this patchset is an urgent
fix.  This part of ptrace has been broken for a very long time and
we've been more or less fine with it.  At least I would be able to
enjoy the sweet delusion that this take is okay for a bit longer.  :-)

-- 
tejun
