Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab1JZPfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:35:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65414 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab1JZPf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:35:29 -0400
Message-ID: <4EA828F4.90204@gmail.com>
Date: Wed, 26 Oct 2011 11:36:20 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: dledford@redhat.com
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, joe.korty@ccur.com, amwang@redhat.com
Subject: Re: [PATCH 2/4] ipc/mqueue: switch back to using non-max values on
 create
References: <1317162613-11060-1-git-send-email-dledford@redhat.com> <1317162613-11060-3-git-send-email-dledford@redhat.com> <CAHGf_=obvkUN-JYVfbLueTV3hmobnV3jY86ukHo1E6d-3NDZxg@mail.gmail.com>
In-Reply-To: <CAHGf_=obvkUN-JYVfbLueTV3hmobnV3jY86ukHo1E6d-3NDZxg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NAK.
> 
> Commit b231cca is 3 years old commit. It's too late to revert.
> Moreover Commit b231cca changed hardcoded limit to kernel knob,
> and this patch do reverse. Of course, latter direction changes almost
> always bring us compatibility issue.
> 
>    commit b231cca4381ee15ec99afbfb244fbc0324869927
>    Author: Joe Korty <joe.korty@ccur.com>
>    Date:   Sat Oct 18 20:28:32 2008 -0700
> 
>        message queues: increase range limits
> 
> The right way is to create new knob likes mqueue/msgsize_default
> and to separate default and maximum value.

I discussed with Doug a little. OK, I probably understand his motivation.
Now, I ack this series with a few reservation.

I'll post a few incremental patches for resolving compatibility issue.
