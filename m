Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2E3Rxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 13:53:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52562 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab2E3Rxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 13:53:44 -0400
MIME-Version: 1.0
In-Reply-To: <1338391644-26777-1-git-send-email-sasikanth.v19@gmail.com>
References: <1338391644-26777-1-git-send-email-sasikanth.v19@gmail.com>
Date: Wed, 30 May 2012 10:53:41 -0700
X-Google-Sender-Auth: Zq5pp-GGKGTAm_zmoAussZRgIgA
Message-ID: <CAGXu5jKM1NH0mgfuCvR38Cs9quhV6m8dYsWd+ZY1QMzsyAkjyA@mail.gmail.com>
Subject: Re: [PATCH v2] prctl: Removed redunant assignment of "error" to zero
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

On Wed, May 30, 2012 at 8:27 AM, Sasikantha babu
<sasikanth.v19@gmail.com> wrote:
> Just setting the "error" to error number is enough on failure and
> It doesn't require to set "error" variable to zero in each switch case, since
> it was already initialized with zero. And also removed return 0 in switch case
> with break statement
>
> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
