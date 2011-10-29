Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1J2XDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 19:03:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50623 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab1J2XDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 19:03:35 -0400
Message-ID: <4EAC8642.3050309@suse.cz>
Date: Sun, 30 Oct 2011 01:03:30 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mikulas Patocka <mpatocka@redhat.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Broken link in /sys/class/net/ [was: [GIT] Networking]
References: <20111025.063206.2273357152859701628.davem@davemloft.net> <CA+55aFw1GVvszqoC_f0RAvG5t1xj0CSYLhLU=y0gQ+_54Gsomw@mail.gmail.com> <20111025131315.GA1899@suse.de>
In-Reply-To: <20111025131315.GA1899@suse.de>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 03:13 PM, Greg KH wrote:
> On Tue, Oct 25, 2011 at 01:46:11PM +0200, Linus Torvalds wrote:
>> Anyway, after that rant about really bad practices, let me say that I
>> did fix up the conflict and I think it's right. But I won't guarantee
>> it, so please check the changes to fs/sysfs/dir.c.
> 
> I think it looks ok, I've booted the merge result, and am typing and
> sending this from the new kernel, and it hasn't crashed yet :)

Hi, maybe this was not caused by the merge, but the patch[1] causes this
mess in /sys/class/net/ for me:
l????????? ? ?    ?    ?             ? eth1

This happens after one renames a net device -- the new name is eth1 here.

[1] 4f72c0cab40 (sysfs: use rb-tree for name lookups)

regards,
-- 
js
suse labs
