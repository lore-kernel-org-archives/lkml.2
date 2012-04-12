Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241Ab2DLNX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 09:23:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38965 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183Ab2DLNX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 09:23:58 -0400
MIME-Version: 1.0
In-Reply-To: <1334123976-11681-6-git-send-email-xiyou.wangcong@gmail.com>
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
	<1334123976-11681-6-git-send-email-xiyou.wangcong@gmail.com>
Date: Thu, 12 Apr 2012 16:23:57 +0300
Message-ID: <CACVxJT_o-mR5u2XgDbECDM-SSR18j+wDY8pd7=Jb+FGCz4SSTQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] proc: use IS_ERR_OR_NULL()
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 8:59 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> -       if (mm && !IS_ERR(mm)) {
> +       if (!IS_ERR_OR_NULL(mm)) {

I personally find original code way more readable.
