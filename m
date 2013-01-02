Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3ACBRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:17:09 -0500
Received: from ozlabs.org ([203.10.76.45]:39337 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab3ACBQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:16:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jonathan Kliegman <kliegs@chromium.org>, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, linux-kbuild@vger.kernel.org,
        Jonathan Kliegman <kliegs@chromium.org>
Subject: Re: [PATCH] modpost: Add flag -f for making section mismatches fatal
In-Reply-To: <1356029364-11346-1-git-send-email-kliegs@chromium.org>
References: <1356029364-11346-1-git-send-email-kliegs@chromium.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 03 Jan 2013 10:26:01 +1030
Message-ID: <87ip7f5ecu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Kliegman <kliegs@chromium.org> writes:
> The section mismatch warning can be easy to miss during the kernel build
> process.  Allow it to be marked as fatal to be easily caught and prevent
> bugs from slipping in.
>
> Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>

Hmm, a CONFIG option with no Kconfig entry?  That seems weird...

Cheers,
Rusty.
