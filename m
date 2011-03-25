Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab1CYXLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:11:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60029 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1CYXL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:11:29 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTike4c7SaeAm5JVWcLyZYt1K59OUEk94rnPeRkMy@mail.gmail.com>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-4-git-send-email-jeffbrown@android.com> <20110325090210.GA5860@polaris.bitmath.org>
 <AANLkTike4c7SaeAm5JVWcLyZYt1K59OUEk94rnPeRkMy@mail.gmail.com>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Fri, 25 Mar 2011 16:10:49 -0700
Message-ID: <AANLkTincFzn7Q+r48LLfkM9taVk3ROmtZDMxvFiBR4m5@mail.gmail.com>
Subject: Re: [PATCH 3/4] input: evdev: Indicate buffer overrun with SYN_DROPPED.
To: Daniel Kurtz <djkurtz@google.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Fri, Mar 25, 2011 at 8:13 AM, Daniel Kurtz <djkurtz@google.com> wrote:
> Would it be useful (and practical) to count the number of currently dropped
> packets and report this count in drop.value?
> Thanks,
> Dan

I don't think it's worth the effort.  It's not clear to me what a
client would actually do with that value.  It doesn't matter much if
10 events or 1000 events were dropped, the net effect is that the
client is out of sync and may need to flush some state in order to
catch up.

Jeff.
