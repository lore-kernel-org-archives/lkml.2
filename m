Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1C3OU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:20:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52790 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab1C3OUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:20:21 -0400
Date: Wed, 30 Mar 2011 16:16:46 +0200
From: Anisse Astier <anisse@astier.eu>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/23] msi-wmi: Use pr_fmt and pr_<level>
Message-ID: <20110330161646.59743cb2@destiny.ordissimo>
In-Reply-To: <03d9dcf405e4a12d137f1fea83bc920f0b8de923.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com>
	<03d9dcf405e4a12d137f1fea83bc920f0b8de923.1301436234.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Tue, 29 Mar 2011 15:21:47 -0700, Joe Perches <joe@perches.com> wrote :

> Added pr_fmt.
> Removed now unused #define DRV_PFX
> Convert dprintk to pr_debug.
> Convert printks to pr_<level>.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Anisse Astier <anisse@astier.eu>

I've been wanting to do that since I replaced original dprintk
implementation with pr_debug. I just didn't know you could use the
pr_fmt() macro to manipulate prefixes.

Regards,

Anisse

> ---
>  drivers/platform/x86/msi-wmi.c |   45 +++++++++++++++++----------------------
>  1 files changed, 20 insertions(+), 25 deletions(-)
> 
