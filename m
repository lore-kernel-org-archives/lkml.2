Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2JPUMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:12:33 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45974 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab2JPUMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:12:31 -0400
MIME-Version: 1.0
In-Reply-To: <20121015165218.GA10239@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-3-git-send-email-rabin@rab.in> <20121015165218.GA10239@redhat.com>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 16 Oct 2012 22:11:50 +0200
X-Google-Sender-Auth: kjML7oQqE-gksY1mABptxTKxBfY
Message-ID: <CAH+eYFBHXAWTinnVO8vEnEhFDQLibwo+BtxYJJYdPcG9__n5OQ@mail.gmail.com>
Subject: Re: [PATCH 3/9] uprobes: allow ignoring of probe hits
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/15 Oleg Nesterov <oleg@redhat.com>:
> On 10/14, Rabin Vincent wrote:
>> Allow arches to decided to ignore a probe hit.  ARM will use this to
>> only call handlers if the conditions to execute a conditionally executed
>> instruction are satisfied.
>
> Not sure I understand why we shouldn't call handlers in this case,
> but OK, I know nothing about arm.

This old discussion about kprobes should be useful:

http://lists.infradead.org/pipermail/linux-arm-kernel/2011-March/045755.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-March/046544.html

> This conflicts with other changes in
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core
>
> Could you re-diff?

OK, I will rebase them.
