Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab2JWQyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:54:46 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56219 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933128Ab2JWQyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:54:43 -0400
MIME-Version: 1.0
In-Reply-To: <1351000104-13015-3-git-send-email-irina.tirdea@intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
	<1351000104-13015-3-git-send-email-irina.tirdea@intel.com>
Date: Tue, 23 Oct 2012 09:54:42 -0700
X-Google-Sender-Auth: yS4NqiiPZqFJNKLeOQgRRnGAtxA
Message-ID: <CAGXu5jKEuMyDhZB4QDLq9yZLQFjXMq2hXhTEToMyQ_rXwc4TZw@mail.gmail.com>
Subject: Re: [PATCH 02/26] pstore: add flags
From: Kees Cook <keescook@chromium.org>
To: Irina Tirdea <irina.tirdea@intel.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Octavian Purdila <octavian.purdila@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 6:48 AM, Irina Tirdea <irina.tirdea@intel.com> wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
>
> Let the back end tweak pstore behaviour.  Flags added are:
>
>         PSTORE_NO_HEADINGS
>
>                 Omit pstore heading lines from dumped data

I wonder if the default should be to not show headers, and to add this
flag to the backends that want the pstore-added header. I think the
more common case going forward will to be without headers since
backends should arguably storing metadata themselves.

Thoughts?

>         PSTORE_MAX_KMSG_BYTES
>
>                 Default kmsg_bytes to ULONG_MAX
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>

Either way, this patch looks logically fine to me.

-Kees

-- 
Kees Cook
Chrome OS Security
