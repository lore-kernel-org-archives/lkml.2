Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1IDSvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 14:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1IDSvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 14:51:32 -0400
Date: Sun, 4 Sep 2011 20:48:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET pm-freezer] freezer: fixes & simplifications
Message-ID: <20110904184809.GA30989@redhat.com>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314988070-12244-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03, Tejun Heo wrote:
>
> These six patches are fixes and simplifications for the recent freezer
> changes.  The first four have been posted twice.  Changes since the
> last posting[L] are
>
> * freezer->state setting bug fix updated per Matt Helsley so that the
>   actual per-task freeze/thaw operations are always performed.
>
> * fixed a bug caused by forgetting to unlock freezer_lock in "freezer:
>   restructure __refrigerator()".
>
> * Two patches added.  The fifth one is mostly trivial.  The sixth a
>   bit more involved but still shouldn't cause any noticeable
>   functional difference.  This removes the buggy and unused
>   freezable_with_signal.

Afaics, everything is fine.

Oleg.

