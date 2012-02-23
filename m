Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2BWHkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 02:40:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62579 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2BWHkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:40:46 -0500
X-AuditID: 9c930197-b7cdbae000001518-ae-4f45ed794e5f
Message-ID: <4F45ED78.2010007@lge.com>
Date: Thu, 23 Feb 2012 16:40:40 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Yuanfang Chen <cyfmxc@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: perf record: can I specify multiple events and use different
 sample-after value
References: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com> <4F4484AC.9050500@lge.com> <CAJh9x3psvYArTQOBQa-TVBsW16qRTPJp+0L8hYJQTK7EJYy1tQ@mail.gmail.com>
In-Reply-To: <CAJh9x3psvYArTQOBQa-TVBsW16qRTPJp+0L8hYJQTK7EJYy1tQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-02-23 3:57 AM, Yuanfang Chen wrote:
> On Wed, Feb 22, 2012 at 1:01 AM, Namhyung Kim <namhyung.kim@lge.com> wrote:
>> 2012-02-22 10:59 AM, Yuanfang Chen wrote:
>> The "-l" option was meaningful only if you specified events more than the
>> actual number of counters in the PMU.
>
> So -l is for multiplexing?
>

The "-l" option is no longer supported in perf record/report and multiplexing 
is always enabled by default, if needed. That would be the same even for old 
versions AFAIK, and "-l" option just controlled whether it'd scale or not the 
counter value which is taken from already multiplexed events.


Thanks,
Namhyung
