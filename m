Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab2JWABr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:01:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39008 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab2JWABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:01:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWGkKQSGzpA5v9XNwi2-CsPodNuH3u+3bARQP_7TPHN1A@mail.gmail.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-17-git-send-email-yinghai@kernel.org>
	<20121022152457.GH22780@phenom.dumpdata.com>
	<CAE9FiQWGkKQSGzpA5v9XNwi2-CsPodNuH3u+3bARQP_7TPHN1A@mail.gmail.com>
Date: Mon, 22 Oct 2012 17:01:45 -0700
X-Google-Sender-Auth: WmBOpUsoKTyuSAfRQykpsQ9v_Xw
Message-ID: <CAE9FiQU=rfZ9qTSDwx9783xOxpsbMrjUfFxXfhfzfjW612VOvQ@mail.gmail.com>
Subject: Re: [PATCH 13/19] x86, mm: only call early_ioremap_page_table_range_init()
 once
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I updated the for-x86-mm branch with updated change log and several
split_mem_range clean up.

Please check them.
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm

At the same time, please do check domU 32bit, that looks like only
path that is not tested yet.

Thanks

Yinghai
