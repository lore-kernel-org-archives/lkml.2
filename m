Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab2JWQuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:50:51 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55891 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2JWQuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:50:50 -0400
MIME-Version: 1.0
In-Reply-To: <1351000104-13015-4-git-send-email-irina.tirdea@intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
	<1351000104-13015-4-git-send-email-irina.tirdea@intel.com>
Date: Tue, 23 Oct 2012 09:50:48 -0700
X-Google-Sender-Auth: sTgm5SOjPcJ9njTLrJdwMuYzWXc
Message-ID: <CAGXu5jLoPmcJ_QZ+ci6RtkS1UWzTg2GnZnD1hG-LHFBogcOPDw@mail.gmail.com>
Subject: Re: [PATCH 03/26] pstore: add flush
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
> Let the back end know when writing has finished by adding a flush method.
>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
