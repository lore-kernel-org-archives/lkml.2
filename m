Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2ICF3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:29:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34446 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2ICF3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:29:38 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-8-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-8-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:29:37 +0300
X-Google-Sender-Auth: tfyiDFkrT2yCHSnIqWF9QYcsP7w
Message-ID: <CAOJsxLHEQF7nQ8yNv+Onh3M4gvOYn2SYNUds=rSfkBH_wAy_9Q@mail.gmail.com>
Subject: Re: [PATCH -v2 07/13] x86, mm: Move down two calculate_table_space_size
 down.
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> So later could make it call split_mem_range...
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

The commit title is utterly confusing. And it has a trailing dot (".").

As for the actual change:

Reviewed-by: Pekka Enberg <penberg@kernel.org>
