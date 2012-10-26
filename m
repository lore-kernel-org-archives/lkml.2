Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2JZAZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:25:56 -0400
Received: from exprod6og103.obsmtp.com ([64.18.1.185]:36350 "EHLO
	exprod6og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2JZAZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:25:54 -0400
Message-ID: <5089D883.1010704@adobe.com>
Date: Thu, 25 Oct 2012 17:25:39 -0700
From: "Paton J. Lewis" <palewis@adobe.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Andreas Jaeger <aj@suse.com>
CC: "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
References: <1345756535-8372-1-git-send-email-palewis@adobe.com> <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com> <5086D27F.1000007@adobe.com> <5086ECDE.4030300@suse.com>
In-Reply-To: <5086ECDE.4030300@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/12 12:15 PM, Andreas Jaeger wrote:
> On 10/23/2012 07:23 PM, Paton J. Lewis wrote:
>> [Re-sending without HTML formatting; all vger.kernel.org destination
>> addresses bounced my original response.]
>>
>> On 10/16/12 8:12 AM, Michael Kerrisk (man-pages) wrote:
>>> [CC += linux-api@]
>>
>> Thank you; is this sufficient to coordinate the required changes to the
>> glibc version of epoll.h?
>
> Paton, we normally review the diffs between kernel versions but noticing
> us via libc-alpha is great.
>
> So, you ask to get this added to <sys/epoll.h>?
>
> #define EPOLL_CTL_DISABLE 4

Yes, that's correct (assuming that v3 the patch proposal is approved).

> Once 3.7 is out and contains it, we will add it. A friendly reminder
> once the patch is in would be nice so that we don't miss it during the
> review.
>
> thanks,
> Andreas
>

Thank you,
Pat
