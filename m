Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab2KRBpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 20:45:39 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43970 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2KRBph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 20:45:37 -0500
Date: Sat, 17 Nov 2012 17:42:12 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Florian Fainelli <ffainelli@freebox.fr>, ccross@android.com,
        tony.luck@intel.com, linux-kernel@vger.kernel.org,
        Maxime Bizon <mbizon@freebox.fr>, stable@vger.kernel.org
Subject: Re: [PATCH v2] pstore/ram: fix undefined usage of
 rounddown_pow_of_two(0)
Message-ID: <20121118014212.GA5556@lizard.sbx05977.paloaca.wayport.net>
References: <1350647942-5260-1-git-send-email-ffainelli@freebox.fr>
 <1350897568-14262-1-git-send-email-ffainelli@freebox.fr>
 <CAGXu5jJhsQ+yGgNRd-sitsusGsuyTjc_Q3DcoSDg4Q=MnJ4agw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jJhsQ+yGgNRd-sitsusGsuyTjc_Q3DcoSDg4Q=MnJ4agw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 08:17:27AM -0700, Kees Cook wrote:
> On Mon, Oct 22, 2012 at 2:19 AM, Florian Fainelli <ffainelli@freebox.fr> wrote:
> > From: Maxime Bizon <mbizon@freebox.fr>
> >
> > record_size / console_size / ftrace_size can be 0 (this is how you
> > disable the feature), but rounddown_pow_of_two(0) is undefined. As suggested
> > by Kees Cook, use !is_power_of_2() as a condition to call rounddown_pow_of_two
> > and avoid its undefined behavior on the value 0. This issue has been present
> > since commit 1894a253 (ramoops: Move to fs/pstore/ram.c).
> >
> > CC: stable@vger.kernel.org
> > Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
> > Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
> 
> Thanks for the fix!
> 
> Acked-by: Kees Cook <keescook@chromium.org>

Applied, thanks!
