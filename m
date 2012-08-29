Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2H2B2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 21:28:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56460 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab2H2B2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 21:28:02 -0400
MIME-Version: 1.0
In-Reply-To: <1346091725.19381.10.camel@pippen.local.home>
References: <1346091725.19381.10.camel@pippen.local.home>
Date: Wed, 29 Aug 2012 09:28:01 +0800
Message-ID: <CAM_iQpV9163UKQt8Kvroc6JyMQnv1tqG1rS5M2CBWzbo7XvJXQ@mail.gmail.com>
Subject: Re: [PATCH] Add feature-removal-schedule.txt removal to feature-removal-schedule.txt
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 2:22 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> The file feature-removal-schedule.txt is ignored by most people except
> for people that add to it. It's more of a global TODO list for
> developers than being anything useful by anyone.
>
> Add a feature removal of removing the feature-removal-schedule.txt.
>

Hi, Steven,

I sometimes remind people to remove features scheduled in this file,
by sending a proposed patch. ;)
