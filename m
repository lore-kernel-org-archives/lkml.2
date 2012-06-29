Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2F2BBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:01:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35968 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab2F2BBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <87hatvx84w.fsf@sejong.aot.lge.com>
References: <20120628103223.GA1055@krava.redhat.com>
	<1340918329-3012-1-git-send-email-jolsa@redhat.com>
	<1340918329-3012-2-git-send-email-jolsa@redhat.com>
	<87hatvx84w.fsf@sejong.aot.lge.com>
Date: Fri, 29 Jun 2012 09:01:05 +0800
Message-ID: <CACV3sb+ykMp0n_c7GwETPnT8bV5UWnM=bVdh3DakNKksK2QNWA@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf, tool: Fix hw breakpoint's type modifier parsing
From: Jovi Zhang <bookjovi@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@ghostprotocols.net,
        a.p.zijlstra@chello.nl, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 8:40 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Thu, 28 Jun 2012 23:18:48 +0200, Jiri Olsa wrote:
>> Fixing the hw breakpoint's type modifier parsing to allow all
>> possible combinations of 'rwx' characters.
>>
>> Adding automated tests to the parsing test suite.
>>
>
> You might need this too:
>
>  Reported-by: Zovi Zhang <bookzovi@gmail.com>
>
> Thanks,
> Namhyung
>

Thanks Namhyung, Jovi Zhang <bookjovi@gmail.com> :)
