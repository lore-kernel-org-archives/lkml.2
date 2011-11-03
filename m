Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1KCWQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:16:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40807 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1KCWQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <201111032313.00082.rjw@sisk.pl>
References: <20111101021511.GP18855@google.com>
	<201111031143.13836.rjw@sisk.pl>
	<20111103150708.GC4417@google.com>
	<201111032313.00082.rjw@sisk.pl>
Date: Thu, 3 Nov 2011 15:16:07 -0700
X-Google-Sender-Auth: 5jYFvJVzJT2e7_Ja9dtKwEz6g6Q
Message-ID: <CAOS58YMEjeJsS-J6ghrVO3W9CyUHLOZ=V-C-Y=xH14QfLUtvsw@mail.gmail.com>
Subject: Re: [PATCH pm] freezer: fix wait_event_freezable/__thaw_task races
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 3, 2011 at 3:12 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Can you repost these two with new changelogs so that there's no confusion
> about what they are doing and why exactly, pretty please?

Will do. :)

>> for-next
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-fix-wait_freezable
>
> Good.  I'll put them into a separate branch and merge them into my linux-next
> branch when 3.2-rc1 is out.

Can you please hold fifteen minutes?  I'm updating the series to
reflect Srivatsa's review.  I'll send pull request soon.

Thank you.

-- 
tejun
