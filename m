Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab2BWTIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:08:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52719 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2BWTIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:08:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dsahern@gmail.com designates 10.68.218.228 as permitted sender) smtp.mail=dsahern@gmail.com; dkim=pass header.i=dsahern@gmail.com
Message-ID: <4F468EBB.9000209@gmail.com>
Date: Thu, 23 Feb 2012 12:08:43 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Yuanfang Chen <cyfmxc@gmail.com>
CC: Namhyung Kim <namhyung.kim@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: perf record: can I specify multiple events and use different
 sample-after value
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com> <4F4484AC.9050500@lge.com> <87ehtnhz9w.fsf@gmail.com> <CAJh9x3prNK+mB7ZACPr_8Gr4nMw5rG45nWwuF__P1=9cB+UN1A@mail.gmail.com> <4F45E9C5.4020900@lge.com> <CAJh9x3o7HLGBWrwBaGgxXS-C9noQbKwh5BP_PAHomOOS6x9SYw@mail.gmail.com> <CAJh9x3o4ELjmrmYhba_R-8G6TciuXY9M3PpjAeCtFNaPmvpKHA@mail.gmail.com>
In-Reply-To: <CAJh9x3o4ELjmrmYhba_R-8G6TciuXY9M3PpjAeCtFNaPmvpKHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/12 11:52 AM, Yuanfang Chen wrote:
>>
>> say my application(not an existing process, so -p<pid>  does not
>> work.) run for 10 seconds. I want the r03c, r2d4 value during each
>> second.  So there will be two values for each event in one second.
>
> oops, forgot to forward. :-)

you are looking for something like this?
http://www.spinics.net/lists/linux-perf-users/msg00211.html

David

