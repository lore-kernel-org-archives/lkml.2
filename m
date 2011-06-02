Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1FBF1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:27:52 -0400
Received: from linux-sh.org ([111.68.239.195]:33100 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab1FBF1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:27:50 -0400
Date: Thu, 2 Jun 2011 14:27:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 13/13] sh: select HAVE_SECCOMP_FILTER
Message-ID: <20110602052714.GB6087@linux-sh.org>
References: <BANLkTimNcag-ZmVTXjUoTyiuJm6jtW0DgA@mail.gmail.com> <1306897845-9393-13-git-send-email-wad@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306897845-9393-13-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 10:10:45PM -0500, Will Drewry wrote:
> Add support for CONFIG_SECCOMP_FILTER by selecting HAVE_SECCOMP_FILTER.
> ---
>  arch/sh/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
