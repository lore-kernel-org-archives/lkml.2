Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2JVPRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:17:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46942 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2JVPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:17:28 -0400
MIME-Version: 1.0
In-Reply-To: <1350897568-14262-1-git-send-email-ffainelli@freebox.fr>
References: <1350647942-5260-1-git-send-email-ffainelli@freebox.fr>
	<1350897568-14262-1-git-send-email-ffainelli@freebox.fr>
Date: Mon, 22 Oct 2012 08:17:27 -0700
X-Google-Sender-Auth: _WLcM4VkjLbRBQ7euROSOaNHnaw
Message-ID: <CAGXu5jJhsQ+yGgNRd-sitsusGsuyTjc_Q3DcoSDg4Q=MnJ4agw@mail.gmail.com>
Subject: Re: [PATCH v2] pstore/ram: fix undefined usage of rounddown_pow_of_two(0)
From: Kees Cook <keescook@chromium.org>
To: Florian Fainelli <ffainelli@freebox.fr>
Cc: cbouatmailru@gmail.com, ccross@android.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 2:19 AM, Florian Fainelli <ffainelli@freebox.fr> wrote:
> From: Maxime Bizon <mbizon@freebox.fr>
>
> record_size / console_size / ftrace_size can be 0 (this is how you
> disable the feature), but rounddown_pow_of_two(0) is undefined. As suggested
> by Kees Cook, use !is_power_of_2() as a condition to call rounddown_pow_of_two
> and avoid its undefined behavior on the value 0. This issue has been present
> since commit 1894a253 (ramoops: Move to fs/pstore/ram.c).
>
> CC: stable@vger.kernel.org
> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
> Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>

Thanks for the fix!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
