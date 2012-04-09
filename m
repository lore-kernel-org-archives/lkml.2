Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2DIDUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 23:20:19 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:60262 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351Ab2DIDUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 23:20:17 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2012 23:20:17 EDT
X-AuditID: 12074423-b7f9c6d0000008c3-a9-4f825444d192
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4F821524.9090702@zytor.com>
Date: Sun, 8 Apr 2012 23:15:07 -0400
Cc: Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4D2D856B-AE62-49D6-9ABE-5238E8B23A6C@mit.edu>
References: <4F80892A.7050104@zytor.com> <4F81D5C4.9000503@openvz.org> <20120408231841.42e28867@pyramind.ukuu.org.uk> <4F8210A5.7000900@zytor.com> <20120408234641.788f8426@pyramind.ukuu.org.uk> <4F821524.9090702@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.1257)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsUixCmqresS0uRv0DtTwGL1+iMsFn9+bmK1
	mLZR3OLyhnNsFudvfWa2uLxrDpvFtqObWS3O/z3O6sDh8eDQZhaP1pObWD0mHf7M5LH5dLXH
	501yHh/Xe3psevKWyeNEyxfWAI4oLpuU1JzMstQifbsEroxZ926wFxxgr9j2cSFzA+MH1i5G
	Tg4JAROJC1desUDYYhIX7q1n62Lk4hAS2McoMXnKYyYIZz2jRNeBw+wQzjEmietbfoO1Cws4
	SGxa2gvWzitgKDHzVTtYnFlAT2LH9V9gNpuAksSdT/vBajgFNCXeHprKBGKzCKhIvNg7jRVk
	KLPATyaJBz/uMUM0a0ssW/iaGWKolcSht7dZITbfY5TYMfkhWEIEqHv6z09MEIfLStw+uJ9p
	AqPgLCSHzEJyyCwkcxcwMq9ilE3JrdLNTczMKU5N1i1OTszLSy3SNdPLzSzRS00p3cQIiht2
	F+UdjH8OKh1iFOBgVOLhVZRt8hdiTSwrrsw9xCjJwaQkymsRCBTiS8pPqcxILM6ILyrNSS0+
	xCjBwawkwvvwWqO/EG9KYmVValE+TEqag0VJnFdD652fkEB6YklqdmpqQWoRTFaGg0NJglcp
	GGioYFFqempFWmZOCUKaiYMTZDgP0PBQkBre4oLE3OLMdIj8KUZdjnuPe68wCrHk5eelSonz
	9oMUCYAUZZTmwc2BpbtXjOJAbwnzTgep4gGmSrhJr4CWMAEtqXlVD7KkJBEhJdXAeOzT+ZbC
	hJU6bquiE3y05F5XKGdnWu6O89rexGHIWmM299R+lQXlT9Rskxc5nne4p+H7/IfB5or9/tLb
	njg8D4l69qN0644r6tO001zuboxNmXXg3IT2/z+97Cf9txZadH6XFGvaZG+XtQfLYjOCZ/Rk
	BL1Yv+/tm5X/85+v+FQw6+QVxUXrFZVYijMSDbWYi4oTAcNsjHpSAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 8, 2012, at 6:45 PM, H. Peter Anvin wrote:

> On 04/08/2012 03:46 PM, Alan Cox wrote:
>>> What if it turns out we can make udev/devtmpfs make this happen
>>> transparently (which it sounds like it might be possible)?  Would you be
>>> okay with removing the "implicit bind mount" property of the current
>>> devpts then?
>> 
>> Once we get to the point where it "just works" I'm quite happy for that
>> to happen unless it turns out there's any large code size/performance
>> hits in having the feature always on. I don't see any.
>> 
> 
> No, it's actually the other way around... it lets us take some pretty
> nice shortcuts.

If it requires making changes to udev, can we place make sure have
a decent amount of time before we remove code from the kernel? 
I really hate it when people break userspace for the convenience
of kernel programmers.   As I recall Linus had something to say
about that….

-- Ted


