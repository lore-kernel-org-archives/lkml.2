Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab2ALCYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:24:13 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35470 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2ALCYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:24:10 -0500
MIME-Version: 1.0
In-Reply-To: <4F0E4333.6070607@lge.com>
References: <1326220106-5765-1-git-send-email-tj@kernel.org>
	<1326220106-5765-10-git-send-email-tj@kernel.org>
	<20120111013212.GA6843@dhcp-172-17-108-109.mtv.corp.google.com>
	<4F0D291A.8030205@lge.com>
	<20120111170635.GE26832@google.com>
	<4F0E31D9.3080306@lge.com>
	<CAOS58YOMKvb5Gj5CeP6t11NHwSdbZWUJ=uC6aRxd6CxpNrwskg@mail.gmail.com>
	<4F0E38E6.4070606@lge.com>
	<CAOS58YNSn079KusXuEYf7agyWgMyaZahp7+4rWRFQz_G3k8CjQ@mail.gmail.com>
	<4F0E3A53.8050208@lge.com>
	<CAOS58YPi5_jsCTqBpNxDyy+cDcr-8WvqUe9r1qBbjdCOT22Q3w@mail.gmail.com>
	<4F0E4333.6070607@lge.com>
Date: Wed, 11 Jan 2012 18:24:08 -0800
X-Google-Sender-Auth: epAsGcTZO717MNzMQeQKRaI-aoc
Message-ID: <CAOS58YPk4uf=nZrFF2PJGpwV2f+zO+m8g-YVDfWr5siaHAm=Ng@mail.gmail.com>
Subject: Re: [PATCH RESEND 9/9] block, trace: implement ioblame - IO tracer
 with origin tracking
From: Tejun Heo <tj@kernel.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>, axboe@kernel.dk, mingo@redhat.com,
        rostedt@goodmis.org, fweisbec@gmail.com, teravest@google.com,
        slavapestov@google.com, ctalbott@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org, winget@google.com,
        Chanho Park <chanho61.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 11, 2012 at 6:19 PM, Namhyung Kim <namhyung.kim@lge.com> wrote:
> I understood it's unreliable. BTW I think that sane userland tool must start
> both of ioblame_io and ioblame_create_intent, say, TPs at once - prior to
> triggering ioblame/enable, obviously. The ioblame/intents can be used as a
> backup just in case.

So, regardless of create_intent TP, the tool has to have code to read
ioblame/intents, right? I just don't see what the benefit of having an
extra interface which can't even be used by itself would be.

Thanks.

-- 
tejun
