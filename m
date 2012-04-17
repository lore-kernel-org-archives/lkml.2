Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab2DQIX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:23:56 -0400
Received: from relay.parallels.com ([195.214.232.42]:47319 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab2DQIXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:23:54 -0400
Message-ID: <4F8D2895.2010404@parallels.com>
Date: Tue, 17 Apr 2012 12:23:49 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "criu@openvz.org" <criu@openvz.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
Subject: Re: [PATCH v2 2/2] IPC: selftest tor new MSG_PEEK_ALL flag for msgrcv()
References: <20120416140235.653.36996.stgit@localhost6.localdomain6>	<20120416140613.653.89845.stgit@localhost6.localdomain6> <20120416151130.732cd0d0.akpm@linux-foundation.org>
In-Reply-To: <20120416151130.732cd0d0.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

17.04.2012 02:11, Andrew Morton пишет:
> On Mon, 16 Apr 2012 18:06:13 +0400
> Stanislav Kinsbursky<skinsbursky@parallels.com>  wrote:
>
>> This test send two messages, then peek them and check, that they are equal to
>> original messages. Then it receives messages and check once more to make sure,
>> that messages are not corrupted or lost after peek operation.
>>
>> ---
>
> Missing signed-off-by.  I added your s-o-b to my copy of the changelog.

Sorry. Thanks.

-- 
Best regards,
Stanislav Kinsbursky
