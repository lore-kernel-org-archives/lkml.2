Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab1AWPxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:53:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54227 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab1AWPxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:53:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=vENdTzO6ijr2wpU8B5fK9QDrZNEOa6bly5oOZQsgCACn4TEODlyj4d9/Z9zbu8wYey
         +Dwy+Bxq4veOnQHf7fmDFkbgBLBigYMEm0zBrb2h6g+xohyECFLaMRhHtPXOVP44QWfM
         JeATnYRRPO5a9Cd3rTax2b5O9ziHjUMr8XjtY=
MIME-Version: 1.0
In-Reply-To: <20110123151556.GA15236@elte.hu>
References: <4d39ce58.cc7e0e0a.5448.59e4@mx.google.com> <alpine.DEB.2.01.1101230243370.7903@trent.utfs.org>
 <20110123145429.GA2523@zhy> <20110123151556.GA15236@elte.hu>
From: Michael Witten <mfwitten@gmail.com>
Date: Sun, 23 Jan 2011 09:53:16 -0600
Message-ID: <AANLkTinSC4cEya8ZVWCJoMwsis3GB1jV87ktEM4LYNaH@mail.gmail.com>
Subject: Re: 'autogroup' sched code KILLING responsiveness
To: Ingo Molnar <mingo@elte.hu>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Christian Kujau <christian@nerdbynature.de>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 09:15, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yong Zhang <yong.zhang0@gmail.com> wrote:
>>
>> I think below patch will fix it.
>
> Christian, Michael, can you confirm...

YES!

As I write this, I'm:

  * Running yes in a VC
  * Running a kernel build
  * Running a 720p HD movie in mplayer

Fantastic!

Thanks,
Michael Witten
