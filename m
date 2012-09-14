Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab2INLnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:43:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60526 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835Ab2INLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:43:46 -0400
Message-ID: <5053186E.6000302@gmail.com>
Date: Fri, 14 Sep 2012 05:43:42 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 3/3 v2] perf tool: give user better message if precise
 is not supported
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com> <1347569955-54626-4-git-send-email-dsahern@gmail.com> <20120914054344.GB9043@gmail.com> <50531151.9020202@gmail.com> <20120914113617.GA13299@gmail.com>
In-Reply-To: <20120914113617.GA13299@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/12 5:36 AM, Ingo Molnar wrote:
> Well, then that is useful information we *lost*, and that
> situation needs to be improved on the ABI side: an expanded
> error code present in the event structure, copied back to
> user-space on errors, or so.
>
> (Alternatively, a special event channel just to pass back
> expanded error conditions.)
>
> Computers are supposed to make life easier for humans, by
> answering such "what did go wrong?" questions. Our losing of
> precise error conditions is a usability bug really - and in the
> perf project we are in a unique position to be able to improve
> both the kernel side code and make immediate use of it on the
> tooling side as well.

Understood and there have been suggestions on how to definitely state 
what the kernel side did not like. I like Peter's last suggestion -- 
something along the lines of clearing attr on a failure except the 
offending setting.

David
