Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2ENQUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:20:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34803 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab2ENQUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <1337012284-18680-1-git-send-email-hdoyu@nvidia.com>
References: <1337012284-18680-1-git-send-email-hdoyu@nvidia.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 14 May 2012 18:20:30 +0200
Message-ID: <CAPXgP11SJQWkfAOidv2nFXAAWxOmjeBpd_uZSCgjX+7+qSH9nQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] printk: Make it compile with !CONFIG_PRINTK
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 6:18 PM, Hiroshi DOYU <hdoyu@nvidia.com> wrote:
> Add missing prepend_timestamp() dummy.

That was fixed already last week:
http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=commitdiff;h=1fce677971e29ceaa7c569741fa9c685a7b1052a

Thanks,
Kay
