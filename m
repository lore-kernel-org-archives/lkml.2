Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512Ab2EITFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:05:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35533 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab2EITFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:05:48 -0400
MIME-Version: 1.0
In-Reply-To: <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
References: <20120509093001.GD8585@gmail.com> <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 May 2012 12:05:26 -0700
X-Google-Sender-Auth: rUua8x-SffghuHJ5Vtt07b8PSWY
Message-ID: <CA+55aFzMotqQ0W9hYPbNpY-7ko77w3-6CfiYdFthXSbUEMVs+Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] kconfig: change config_enabled() to accept X instead
 of CONFIG_X
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, paul.gortmaker@windriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 11:46 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> change config_enabled() to use it as config_enabled(SMP) instead of
> config_enabled(CONFIG_SMP).

People hated this when I suggested it, and I kind of understand why.

It breaks greppability of CONFIG_xyz.

So I think I'd have to NAK this.

                   Linus
