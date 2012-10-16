Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab2JPFOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:14:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62435 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2JPFOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <20121013022956.036433758@goodmis.org>
References: <20121013022632.024527228@goodmis.org>
	<20121013022956.036433758@goodmis.org>
Date: Tue, 16 Oct 2012 09:14:03 +0400
Message-ID: <CAMo8Bf+isk4HrB7MesgooqmNYuWUjLaifkB9kw3ENdQk7tL1eQ@mail.gmail.com>
Subject: Re: [PATCH 25/25] xtensa: Use Kbuild infrastructure to handle
 asm-generic headers
From: Max Filippov <jcmvbkbc@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 6:26 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> Use Kbuild infrastructure to handle the asm-generic headers
> and remove the wrapper headers that call them.
>
> This only affects headers that do nothing but include the generic
> equivalent. It does not touch any header that does a little more.
>
> Cc: linux-kbuild@vger.kernel.org
> Cc: linux-xtensa@linux-xtensa.org
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Thanks, rebased on top of UAPI changes and applied to
the xtensa_next tree.

-- 
-- Max
