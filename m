Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab2BJR4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:56:46 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64869 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2BJR4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:56:45 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1202050136330.30244@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202050136330.30244@swampdragon.chaosbits.net>
Date: Fri, 10 Feb 2012 09:56:44 -0800
X-Google-Sender-Auth: V3jNzjDhFgKTawCz4Hy-7_-_Mw0
Message-ID: <CAA9_cmcUW6NUr6MvLQqZ6BCgoyfbcdoJxGjTmiD8nKfnwvCYkg@mail.gmail.com>
Subject: Re: [PATCH] SCSI, ISCSI: Just #include "host.h" once in host.c
From: Dan Williams <dan.j.williams@intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-scsi@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Ed Nadolski <edmund.nadolski@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Intel SCU Linux support <intel-linux-scu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 4:37 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> There's no need to include the header twice.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---

Thanks, applied.
