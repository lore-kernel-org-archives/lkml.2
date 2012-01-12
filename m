Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2ALCTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:19:45 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63649 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2ALCTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:19:44 -0500
X-AuditID: 9c930179-b7ba8ae00000598d-94-4f0e43335b32
Message-ID: <4F0E4333.6070607@lge.com>
Date: Thu, 12 Jan 2012 11:19:31 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Namhyung Kim <namhyung@gmail.com>, axboe@kernel.dk, mingo@redhat.com,
        rostedt@goodmis.org, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com,
        Chanho Park <chanho61.park@samsung.com>
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
References: <1326220106-5765-1-git-send-email-tj@kernel.org> <1326220106-5765-10-git-send-email-tj@kernel.org> <20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com> <4F0D291A.8030205@lge.com> <20120111170635.GE26832@google.com> <4F0E31D9.3080306@lge.com> <CAOS58YOMKvb5Gj5CeP6t11NHwSdbZWUJ=uC6aRxd6CxpNrwskg@mail.gmail.com> <4F0E38E6.4070606@lge.com> <CAOS58YNSn079KusXuEYf7agyWgMyaZahp7+4rWRFQz_G3k8CjQ@mail.gmail.com> <4F0E3A53.8050208@lge.com> <CAOS58YPi5_jsCTqBpNxDyy+cDcr-8WvqUe9r1qBbjdCOT22Q3w@mail.gmail.com>
In-Reply-To: <CAOS58YPi5_jsCTqBpNxDyy+cDcr-8WvqUe9r1qBbjdCOT22Q3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-12 10:44 AM, Tejun Heo wrote:
> On Wed, Jan 11, 2012 at 5:41 PM, Namhyung Kim<namhyung.kim@lge.com>  wrote:
>> OK, but that can be controlled from userspace, I guess? Do we have to care
>> about that?
>
> Otherwise, it's gonna be a pretty silly interface. If you want to
> watch the TP, you have to restart the whole thing which also implies
> intent number would change. And there still is the problem of losing
> new intent events due to overflow. It just isn't the right interface
> for the task.
>

I understood it's unreliable. BTW I think that sane userland tool must 
start both of ioblame_io and ioblame_create_intent, say, TPs at once - 
prior to triggering ioblame/enable, obviously. The ioblame/intents can 
be used as a backup just in case.

Thanks,
Namhyung Kim
