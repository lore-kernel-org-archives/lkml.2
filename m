Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab2AMCR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 21:17:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54220 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab2AMCRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 21:17:24 -0500
MIME-Version: 1.0
In-Reply-To: <1324964554-9719-1-git-send-email-ming.m.lin@intel.com>
References: <1324964554-9719-1-git-send-email-ming.m.lin@intel.com>
Date: Fri, 13 Jan 2012 10:17:23 +0800
X-Google-Sender-Auth: Zy1PGGkvKOjGQk-JQQIOoRz6t1s
Message-ID: <CAF1ivSbwO+D1Z4A=A7wPunDOOkZxthRAn_TEX_osyJozdZNFcg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ahci controller runtime PM support
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 1:42 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> Hi all,
>
> Here is the v2 patches to add ahci controller runtime PM support.
> Applied on top of linux-next tree.
>
> Thanks for any comments.

Any comment?

Thanks,
Lin Ming

>
> v2:
> - add ahci hibernate callbacks
>
> v1:
> https://lkml.org/lkml/2011/12/15/198
>
> Lin Ming (3):
>      ahci: port legacy pm interface to struct dev_pm_ops
>      ahci: add runtime PM callbacks
>      ata: runtime suspend port if no device attached
>
>  drivers/ata/ahci.c        |   71 +++++++++++++++++++++++++++++++++++++++-----
>  drivers/ata/libata-core.c |   21 ++++++++++++-
>  2 files changed, 83 insertions(+), 9 deletions(-)
>
