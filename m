Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425Ab2DKVYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 17:24:42 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49431 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933381Ab2DKVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 17:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <201204111628.q3BGSEm2005145@farm-0002.internal.tilera.com>
References: <201204111628.q3BGSEm2005145@farm-0002.internal.tilera.com>
Date: Wed, 11 Apr 2012 14:24:40 -0700
X-Google-Sender-Auth: bCveYtNKfxe6qFMJvT08qxRaujE
Message-ID: <CAA9_cmfkH+niTtkA2dvO7ts-ia1T7tNKHz6rNXwJLtxzOwOvkg@mail.gmail.com>
Subject: Re: [PATCH] mvsas: get rid of a dead variable that causes a warning
From: Dan Williams <dan.j.williams@intel.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        Xiangliang Yu <yuxiangl@marvell.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 9:23 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> The "dev" variable in mvs_task_exec() is no longer used and
> generates a warning when building the kernel.
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Thanks, I I have this one sitting in isci.git

http://git.kernel.org/?p=linux/kernel/git/djbw/isci.git;a=commitdiff;h=594a1fcd

I'm planning to roll that into to libsas-fixes update (pending some
acks on other patches in that set).

--
Dan
