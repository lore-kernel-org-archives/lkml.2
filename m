Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab1FXAmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:42:38 -0400
Received: from outmail021.snc4.facebook.com ([66.220.144.153]:57116 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932659Ab1FXAmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:42:36 -0400
Message-ID: <4E03DDB0.3050502@fb.com>
Date: Thu, 23 Jun 2011 17:43:28 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: David Ahern <dsahern@gmail.com>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Using a new perf tool against an older kernel
References: <4E026123.4060208@fb.com> <4E034C2C.30509@gmail.com> <4E03968A.5010008@fb.com> <20110624001100.GD8058@somewhere.redhat.com>
In-Reply-To: <20110624001100.GD8058@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/11 5:11 PM, Frederic Weisbecker wrote:

>
> I'm confused, you first said it happens with new tools on older kernel.
>
> Can you tell us which combination of kernel/user raises the error? and
> which error.
>

perf-3.0 + 2.6.38

perf record -agR gives:

Can't find id 9's machine
Found 1 unknown events!

perf-3.0 + 2.6.32

perf record -ag
perf script

samples have bogus timestamps

perf-3.0 + 2.6.32

perf record -agR
perf script

error: Samples do not contain timestamps

perf-3.0 + any kernel

perf record -agT
perf script

is happy everywhere. Thanks!

  -Arun

