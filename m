Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab1GKRYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:24:17 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21815 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758007Ab1GKRYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:24:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=sXYSwhcTG0zEjzXKth8P/hB35be620ujPO4yQD57UYf0fxHkaS7dIVeUkPlW1x/ai
	/J+CoKToBAOO324N4Nu+g==
MIME-Version: 1.0
In-Reply-To: <1310288313-4908-1-git-send-email-wanlong.gao@gmail.com>
References: <1310288313-4908-1-git-send-email-wanlong.gao@gmail.com>
From: Paul Menage <menage@google.com>
Date: Mon, 11 Jul 2011 10:23:53 -0700
Message-ID: <CAJniumXsZ=DDBHxp_RtdhcZ0n8efdyjSZCERn8H1H3G3AnCf2w@mail.gmail.com>
Subject: Re: [PATCH] Doc:cgroup:fix a cpuset's file description in cpusets.txt
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 1:58 AM, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> Only the root cpuset has cpuset.memory_pressure_enabled flag,
> but not the only one.
>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

The original was actually correct English, when parsed as "(the root
cpuset only) (has the following file)", but I guess ambiguous. I'd be
inclined to just remove the word "only", since it's unnecessary in its
new location.

Paul
