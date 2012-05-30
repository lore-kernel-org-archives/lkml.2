Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab2E3S2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:28:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59499 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2E3S2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:28:44 -0400
Date: Wed, 30 May 2012 13:28:35 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Sasikantha babu <sasikanth.v19@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        James Morris <james.l.morris@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] prctl: Removed redunant assignment of "error" to zero
Message-ID: <20120530182835.GA12122@amd1>
References: <1338391644-26777-1-git-send-email-sasikanth.v19@gmail.com>
 <CAGXu5jKM1NH0mgfuCvR38Cs9quhV6m8dYsWd+ZY1QMzsyAkjyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKM1NH0mgfuCvR38Cs9quhV6m8dYsWd+ZY1QMzsyAkjyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> On Wed, May 30, 2012 at 8:27 AM, Sasikantha babu
> <sasikanth.v19@gmail.com> wrote:
> > Just setting the "error" to error number is enough on failure and
> > It doesn't require to set "error" variable to zero in each switch case, since
> > it was already initialized with zero. And also removed return 0 in switch case
> > with break statement
> >
> > Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>
> 
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: Serge E. Hallyn <serge@hallyn.com>

> 
> -Kees
> 
> -- 
> Kees Cook
> Chrome OS Security
