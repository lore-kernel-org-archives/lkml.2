Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1GCI1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:27:35 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54400 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab1GCI1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:27:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110628144808.GC2472@redhat.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1309244992-2305-10-git-send-email-jim.cromie@gmail.com> <20110628144808.GC2472@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 3 Jul 2011 10:27:13 +0200
X-Google-Sender-Auth: __mNb8yBR2LKmDAwZiandZAkTR8
Message-ID: <CAO+b5-oXSgO-XvTuBiuqHK5Wc-9MeE5goZ-xbhyM=G3-4oOewA@mail.gmail.com>
Subject: Re: [PATCH 09/11] dynamic_debug: add_to_pending() saves non-matching
 queries for later.
To: Jason Baron <jbaron@redhat.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        gnb@fmeh.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 4:48 PM, Jason Baron <jbaron@redhat.com> wrote:
> A number of ppl have expressed interest to me in this functionality...
>
> I'm wondering if we should call out this usage explicitly with a new
> flag like '+a'. Meaning 'add' as a pending query if it doesn't match
> anything existing.
>
> In this way, we can have error when things don't match in the normal case.
> Otherwise, somebody might think they've enabled something when they've in fact
> added a pending query.

That suggestion makes sense to me - I think it's better that the user
makes it explicit whether or not a query should be added to the
pending list instead of the ddebug code trying to find out which list
a query should be added to.

Bart.
