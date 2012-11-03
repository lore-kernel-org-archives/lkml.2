Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2KCI3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 04:29:18 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47097 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2KCI3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 04:29:15 -0400
Message-ID: <5094D44E.8030808@gmail.com>
Date: Sat, 03 Nov 2012 09:22:38 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
CC: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: enabling psacct breaks fsfreeze
References: <20121023094351.GC27919@pcnci.linuxbox.cz> <20121031121517.GD18424@quack.suse.cz> <20121031124600.GM20752@pcnci.linuxbox.cz> <20121101093723.GC6584@quack.suse.cz> <20121101111957.GD6584@quack.suse.cz> <20121101142325.GD20752@pcnci.linuxbox.cz> <20121101225053.GB31937@quack.suse.cz> <5093977A.9010507@gmail.com> <20121102104018.GG20752@pcnci.linuxbox.cz>
In-Reply-To: <20121102104018.GG20752@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/11/2012 11:40, Nikola Ciprich ha scritto:
>> I saw this behavior (task-hang) when I tested the fsfreeze code. I was
>> writing a little patch to replace fsfreeze's wait queue with a killable
>> queue, in this way the user can do at least "kill -9", but since the
>> behavior was the same before your patch I didn't send it. I don't know if we
>> can break any previous behavior. The funny thing here is that it's like if
>> fsfreeze freezes itself :)
>
> I think freezing all tasks ain't that bad, my problem is it's not possible to
> start fsfreeze -u to thaw filesystem..
>
>

Yes, of course. It was only a general comment.

Marco
