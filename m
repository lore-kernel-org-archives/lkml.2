Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422928Ab2JaNwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:52:44 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59544 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935587Ab2JaNv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:51:58 -0400
X-Greylist: delayed 85512 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2012 09:51:58 EDT
X-AuditID: b753bd60-928c4ba0000047ca-50-50912cfc446b
Message-ID: <50912CFB.5000508@hitachi.com>
Date: Wed, 31 Oct 2012 22:51:55 +0900
From: Mitsuhiro Tanino <mitsuhiro.tanino.gm@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Patch 0/2] Exclude hwpoison page from vmcore dump
References: <508FDEF3.8030601@hitachi.com> <20121030143750.GF2290@redhat.com>
In-Reply-To: <20121030143750.GF2290@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

(2012/10/30 23:37), Vivek Goyal wrote:
> Why to introduce this option "-p"? Until and unless there are serious
> side effects, this should be default functionality. Isn't it? Who would
> like to touch/save poisoned pages and run into MCE?

Thank you for your review of my patch.

In my understanding, hwpoison is a function which is only supported at
high end servers and most of users do not use this function.
Therefore, I think this functionality was better for option.

On the other hand, as you say, nobody wants to touch/save poisoned pages
and run into MCE, and it is desirable for users to exclude hwpoison pages
automatically. I agree with you.

I will post fixed patch without "-p" option. Please help to review it.

Subject: 
[PATCH 0/2 v2] Exclude hwpoison page from vmcore dump
[PATCH 1/2 v2] makedumpfile: Add a default action to exclude hwpoison page from vmcore
[PATCH 2/2 v2] kexec: Export PG_hwpoison flag into vmcoreinfo

Regards,
Mitshuhiro Tanino (mitsuhiro.tanino.gm@hitachi.com)

