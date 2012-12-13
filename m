Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2LMMhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 07:37:24 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57100 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab2LMMhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 07:37:22 -0500
MIME-Version: 1.0
In-Reply-To: <1355397760-17768-1-git-send-email-abogani@kernel.org>
References: <1355397760-17768-1-git-send-email-abogani@kernel.org>
Date: Thu, 13 Dec 2012 13:37:21 +0100
Message-ID: <CANGUGtAts1RVfNBmaaxpTs4VNRwwpu_rP+6jjqfv-4to=4hDEA@mail.gmail.com>
Subject: Re: vfs: Remove useless function prototypes
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/13 Alessio Igor Bogani <abogani@kernel.org>:
> Commit 8e22cc88d68ca1a46d7d582938f979eb640ed30f removes the (un)lock_super
> function definitions but forgets to remove their prototypes.
>
> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
> ---

Yep, my fault :)

Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
