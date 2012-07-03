Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2GCExj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:53:39 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:52695 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2GCExg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:53:36 -0400
MIME-Version: 1.0
In-Reply-To: <1341275894-9737-1-git-send-email-alex.page.kelly@gmail.com>
References: <1341275894-9737-1-git-send-email-alex.page.kelly@gmail.com>
Date: Tue, 3 Jul 2012 12:53:34 +0800
Message-ID: <CAM_iQpWk7nekZoi5i6yg6Q3hA6Sa1HG2SPjPJ=HFD3cPdbVW9w@mail.gmail.com>
Subject: Re: [PATCH 1/2] Moved core dump functionality into its own file
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Alex Kelly <alex.page.kelly@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex <eshink@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 8:38 AM, Alex Kelly <alex.page.kelly@gmail.com> wrote:
> From: Alex <eshink@gmail.com>
>
> This was done in preparation for making core dump functionality optional.
>
> The variable "suid_dumpable" and associated functions are left in fs/exec.c
> because they're used elsewhere, such as in ptrace.
>
> Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Looks good to me:

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
