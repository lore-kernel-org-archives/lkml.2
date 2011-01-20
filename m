Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1ATFav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 00:30:51 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33066 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1ATFas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 00:30:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nqug0Z9sz8cUxs3bRkHelGdntsMd7mw5hrKCRrR7bIC/W4eFB0/3+gn6Dzq8QZibLN
         3VkgJUw5wYEXMZMH+u8GGlSraaoY9s6B7x9R0JesfEYEv8feOqSAsAxEZB8FfBXd8+/E
         m3FV38305J/F5reriVcbLfn+LPyqQqmIm3IN0=
MIME-Version: 1.0
In-Reply-To: <1295499568.8027.30.camel@marge.simson.net>
References: <1295275365.12840.13.camel@kolo>
	<1295280032.30950.128.camel@laptop>
	<1295339012.11678.35.camel@kolo>
	<AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	<1295357746.30950.681.camel@laptop>
	<AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	<1295430276.30950.1414.camel@laptop>
	<1295433498.30950.1482.camel@laptop>
	<1295436632.30950.1542.camel@laptop>
	<1295441881.11678.41.camel@kolo>
	<1295442799.11678.43.camel@kolo>
	<1295443822.28776.23.camel@laptop>
	<AANLkTinQ4sczEwZYCk1_tLmeJyjyXj4TVoSZbjg+KiRq@mail.gmail.com>
	<1295499568.8027.30.camel@marge.simson.net>
Date: Thu, 20 Jan 2011 13:30:47 +0800
Message-ID: <AANLkTikEwgMzco2fHT668Mg3fC-T3EBMUgQQqW-Ojj-Y@mail.gmail.com>
Subject: Re: Bug in scheduler when using rt_mutex
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, samu.p.onkalo@nokia.com,
        mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 12:59 PM, Mike Galbraith <efault@gmx.de> wrote:
> or the task is enqueued
> at it's last offset as usual for runnable tasks.

But shouldn't we task the tasks as WAKEUP, through the task has been
waked on other sched_class?
IOW, I wonder if we should play with place_entity() at some point.

Thanks,
Yong

-- 
Only stand for myself
