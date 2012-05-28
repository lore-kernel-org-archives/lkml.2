Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2E1MIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:08:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57280 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab2E1MIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:08:11 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXhoJVo5c2+bzG=+okgh=++11ndhskwR6r+PX8hNjQ_6Bw@mail.gmail.com>
References: <CANQmPXhyAavikU=861nVA3WjPsMjBt+XOTUJ08VAoinZ1gCRzQ@mail.gmail.com>
	<CAJd=RBDN7q0C+ktY29B66d9coyy1BGESOHCHFmFQVboOfNXq5w@mail.gmail.com>
	<CANQmPXi+O-bHFzbi1q5g0GuKgXmeyEYp+UB_61YDDd2uE475GA@mail.gmail.com>
	<CANQmPXipw9QPEc9xMuCLDW14W3w5VeUYZP1GJnvR+D57xCWksA@mail.gmail.com>
	<CAJd=RBC5=JHEUD7N4cQc87AkkgYc-VS+TBEza6QMomA1DsOL1g@mail.gmail.com>
	<CANQmPXhpV1Hq11FM4vwN7yneGQ7F7wC0Mh+zGCPgNgxry8xLqg@mail.gmail.com>
	<20120528113903.GA5187@fancy-poultry.org>
	<CANQmPXhoJVo5c2+bzG=+okgh=++11ndhskwR6r+PX8hNjQ_6Bw@mail.gmail.com>
Date: Mon, 28 May 2012 20:08:11 +0800
Message-ID: <CANQmPXh+Bnn19DZHa-028T9gEjQ2C+iyqQPD_4tYs7SAES2-_g@mail.gmail.com>
Subject: Re: [ANNOUNCE][PATCH 5/26]Rotary Interactivity Favor Scheduler
 Version 3(Brain-Eating) Update.
From: Chen <hi3766691@gmail.com>
To: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 8:03 PM, Chen <hi3766691@gmail.com> wrote:
> This is not the regular patch!The regular one is on
> http://rifs-scheduler.googlecode.com
>
> 在 2012-5-28 下午7:39，"Heinz Diehl" <htd@fancy-poultry.org>写道：
>
>> On 28.05.2012, Chen wrote:
>>
>> > This is the patch
>>
>> What you posted is a patch on the BFS-4.20 patch (by Con Kolivas)
>> itself, and not a patch against an actual kernel tree. The output
>> has a format which is totally unreadable and disgusting,
>> and I can't apply it without tinkering with BFS first,
>> (which is designed for 3.3.x and needs a merge into 3.4.0 on top of that)
>>
>> Could you please provide a clean patch which is based on one of the
>> current trees?
>>
>> Besides, it seems to me that you are trying to reinvent the wheel
>> using a lot of pieces of Con's -ck patch..
>>
>> Thanks,
>> Heinz.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

This is a diff between bfs and rifs actually.
Also RIFS and BFS are different scheduler.
Former one use the algorithm I 've invented(O(1) implementation ),
latter one use EEVDF(O(n) implementation)
