Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2INLOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 07:14:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43608 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2INLN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 07:13:29 -0400
Message-ID: <50531151.9020202@gmail.com>
Date: Fri, 14 Sep 2012 05:13:21 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 3/3 v2] perf tool: give user better message if precise
 is not supported
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com> <1347569955-54626-4-git-send-email-dsahern@gmail.com> <20120914054344.GB9043@gmail.com>
In-Reply-To: <20120914054344.GB9043@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/12 11:43 PM, Ingo Molnar wrote:
>> v2: softened message to 'may not be' supported per Robert's suggestion
>
> Well, either it's supported on this machine or it's not - why
> does the text have to be so unsure about it?

Because EOPNOTSUPP is returned for more than just precise mode. We 
cannot say with certainty that the precise attribute caused that errno.

David


