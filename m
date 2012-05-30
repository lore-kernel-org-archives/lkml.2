Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2E3PH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:07:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46234 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2E3PHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:07:55 -0400
MIME-Version: 1.0
In-Reply-To: <1338371703-28858-1-git-send-email-sasikanth.v19@gmail.com>
References: <1338371703-28858-1-git-send-email-sasikanth.v19@gmail.com>
Date: Wed, 30 May 2012 08:07:53 -0700
X-Google-Sender-Auth: PmG8HaoKEoCqahULJT76mtNSXkM
Message-ID: <CAGXu5jKFnTyb7WBVP1xc444B90P3uOdhKt5PZGSfHBdWOiTNrQ@mail.gmail.com>
Subject: Re: [PATCH] prctl: Removed redunant assignment of "error" to zero
From: Kees Cook <keescook@chromium.org>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 2:55 AM, Sasikantha babu
<sasikanth.v19@gmail.com> wrote:
> Just setting the "error" to error number is enough on failure and
> It doesn't require to set "error" variable to zero in each switch case, since
> it was already initialized with zero

This looks fine. Can you include an additional clean up in this? It
looks like PR_SET_NAME and PR_GET_NAME both 'return 0' instead of
using 'break' like all the rest.

-Kees

-- 
Kees Cook
Chrome OS Security
