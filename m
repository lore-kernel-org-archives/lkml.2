Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab2FSBOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:14:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37575 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2FSBOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:14:23 -0400
Message-ID: <4FDFD26A.4040702@gmail.com>
Date: Mon, 18 Jun 2012 19:14:18 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: rostedt@goodmis.org, acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        weisbec@gmail.com, namhyung.kim@lge.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd
 plugins
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com> <87lijlhv9v.fsf@sejong.aot.lge.com> <4FDF3D5C.1030209@gmail.com> <87d34wi0y3.fsf@sejong.aot.lge.com>
In-Reply-To: <87d34wi0y3.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/12 6:45 PM, Namhyung Kim wrote:
>> kvm tracepoints are fine; perf just doesn't handle their (advanced)
>> formatting.
>>
>
> Yeah, I think it's a libtraceevent's issue, not perf's. Please see
> below:

Well documented problem (search perf kvm bad op token.

In April 2011 (pre first libparseevent patch) I mentioned a 
desire/wish/dream for perf to be able to use trace-cmd's plugins to fix 
this:

http://lkml.indiana.edu/hypermail/linux/kernel/1104.1/00411.html

Maybe this dream can come true... ;-)

David
