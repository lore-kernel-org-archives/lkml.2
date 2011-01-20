Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab1ATDLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 22:11:00 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64714 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab1ATDK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 22:10:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EaKoXkK7bohU1XZUrUTz/9jBlNedCNHY9yL5NvOwXDYEiSA+3rTzx1eKcwOIP9EbtY
         pvjF+ytBT2Q7QWla9SYSaPviAtuIDyE1axBblskt/7yxneUTHHfGlrotBVJDPD8pMZMU
         teEXszfEUXtKs6m0bj0e5qOlD7tZtS55dLLeA=
MIME-Version: 1.0
In-Reply-To: <1295430276.30950.1414.camel@laptop>
References: <1295275365.12840.13.camel@kolo>
	<1295280032.30950.128.camel@laptop>
	<1295339012.11678.35.camel@kolo>
	<AANLkTikXf-OMEBx-UZktxooOs+YqUkSE9doyEZopjzOx@mail.gmail.com>
	<1295357746.30950.681.camel@laptop>
	<AANLkTimLSict5oq5PefDaMLB9q2fK91E8XgbUDEohP-_@mail.gmail.com>
	<1295430276.30950.1414.camel@laptop>
Date: Thu, 20 Jan 2011 11:10:57 +0800
Message-ID: <AANLkTikT+YDhk4Orua+krhQs+jNy+8BxH6YVbHqD1oOG@mail.gmail.com>
Subject: Re: Bug in scheduler when using rt_mutex
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: samu.p.onkalo@nokia.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 5:44 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> more or less, the idea is that we only call __{dequeue,enqueue}_entity()
> when the task is actually in the tree and current is not.

Sure ;)
