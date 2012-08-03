Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2HCRFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 13:05:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42770 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2HCRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 13:05:52 -0400
MIME-Version: 1.0
In-Reply-To: <1344003450-4245-1-git-send-email-sacchi@gmail.com>
References: <1344003450-4245-1-git-send-email-sacchi@gmail.com>
Date: Fri, 3 Aug 2012 22:35:50 +0530
Message-ID: <CAM+duDHepHAVCK6+9bQW0oDLwogaCMhjEgj+-ZJ4pkSzbH=pmw@mail.gmail.com>
Subject: Re: [PATCH] Documentation/filesystems/porting: Update documentation.
From: Vijay Bellur <vbellur@gmail.com>
To: Sachidananda Urs <sacchi@gmail.com>
Cc: Rob Landley <rob@landley.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 7:47 PM, Sachidananda Urs <sacchi@gmail.com> wrote:
> ->get_sb() is no longer used, update documentation to use ->mount(). Also added
>   a example for struct file_system_type.
>
> Signed-off-by: Sachidananda Urs <sacchi@gmail.com>
> ---
>  Documentation/filesystems/porting |   20 +++++++++++++-------
>  1 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
> index 2bef2b3..d6d53fb 100644

> +static struct file_system_type foo_fs_type = {
> +        .owner  = THIS_MODOULE,

s/MODOULE/MODULE/

-Vijay
