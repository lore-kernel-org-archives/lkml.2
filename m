Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0IVCIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 22:08:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517Ab0IVCIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 22:08:37 -0400
Date: Tue, 21 Sep 2010 19:08:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Hill <joshua.hill@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        alan@redhat.com, stable@kernel.org, Thomas Renninger <trenn@suse.de>,
        Matthew Garrett <mjg@redhat.com>, "Zhang, Rui" <rui.zhang@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [2.6.35-rc5] hp-wmi patch missed .35 merge window, requesting
 addition to next rc
Message-Id: <20100921190816.e6ca6a72.akpm@linux-foundation.org>
In-Reply-To: <AANLkTimOVY+iOOMKhwFfX5Wcw1y_PcvoCCfEcjoPmj3J@mail.gmail.com>
References: <AANLkTimOVY+iOOMKhwFfX5Wcw1y_PcvoCCfEcjoPmj3J@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

On Tue, 21 Sep 2010 10:23:57 -0700 Josh Hill <joshua.hill@gmail.com> wrote:

> please cc as i'm unsubscribed
> as reported in this bug: https://bugzilla.kernel.org/show_bug.cgi?id=15344
> and the patch: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=751ae808f6b29803228609f51aa1ae057f5c576e
> 
> the backlight on this laptop goes down one level whenever
> /proc/acpi/ac_adapter/*/status is read.
> i've been told the patch missed the .35 merge window, and is going to
> be in .36, but ubuntu is
> going to release 10.10 soon with .35 in it, and if this patch doesn't
> make it into .35 my laptop
> will be doing this for its (10.10) entire lifetime. i didn't know who
> to really contact and request this sort
> of thing so i'm doing it here.

The suggestion is that mainline's
751ae808f6b29803228609f51aa1ae057f5c576e ("x86 platform drivers: hp-wmi
Reorder event id processing") be backported into 2.6.35.x to fix the
post-2.6.32 regression described in
https://bugzilla.kernel.org/show_bug.cgi?id=15344


