Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab0KOMqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 07:46:34 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36338 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab0KOMqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 07:46:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=Sw8rMngJaBNQt0+zVWNV7dRaQjEx7sfKzMl3zBoBbwfM2x9vV8uqoQFCwZ7Ycy+RW7
         JZkdu/wKQ1OQpnPsXobOn9zfR9yg6b+F1GJQRY3Jr7WR81RMsnyHNu56STKmtJ55rwE9
         oUnjkqRX7QQPoyiwInkTa/oXxTlQRzw2+nxRI=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
In-Reply-To: <20101115162713.BF12.A69D9226@jp.fujitsu.com>
References: <20101115160413.BF0F.A69D9226@jp.fujitsu.com> <AANLkTim0vCJkMoH5P0wCN9J6340rDsscyNBQ+R+_ph8m@mail.gmail.com> <20101115162713.BF12.A69D9226@jp.fujitsu.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Mon, 15 Nov 2010 07:46:26 -0500
Message-ID: <87tyjisqjh.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 16:28:32 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> Who can make rsync like io pattern test suite? a code change is easy. but
> to comfirm justification is more harder work.
> 
I'm afraid I don't have time to work up any code. I would be happy to
try the patch with my backup use-case though. I'll just have to think
of an objective way of measuring the result.

- Ben
