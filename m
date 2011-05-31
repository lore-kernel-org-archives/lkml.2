Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485Ab1EaJB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 05:01:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:57000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab1EaJBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 05:01:54 -0400
Message-ID: <4DE4AE80.9040904@suse.cz>
Date: Tue, 31 May 2011 11:01:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] kbuild: Fix <linux/version.h> for X.Y versions
References: <1306767052-15593-1-git-send-email-mmarek@suse.cz>            <1306767052-15593-3-git-send-email-mmarek@suse.cz> <5164.1306768129@turing-police.cc.vt.edu>
In-Reply-To: <5164.1306768129@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.5.2011 17:08, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 30 May 2011 16:50:50 +0200, Michal Marek said:
>
>> +	expr $(VERSION) \* 65536 + $(PATCHLEVEL) \* 256 + 0$(SUBLEVEL));    \
>
> expr isn't going to interpret that last field as octal, is it?

As I wrote in the changelog: "expr treats all numbers as decimals, so 
prepending a zero is safe." POSIX requires this, FWIW.

Michal
