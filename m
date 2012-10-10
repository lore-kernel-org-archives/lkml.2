Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2JJPOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:14:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49455 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab2JJPOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:14:38 -0400
MIME-Version: 1.0
In-Reply-To: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1349866585-24883-1-git-send-email-dp@opensource.wolfsonmicro.com>
Date: Wed, 10 Oct 2012 23:14:36 +0800
Message-ID: <CACVXFVMvq-OoLOowds-4-PGyrtmZW2oAQATiTonJs7LvWc1aCA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Expose firmware paths via procfs
From: Ming Lei <ming.lei@canonical.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 6:56 PM, Dimitris Papastamos
<dp@opensource.wolfsonmicro.com> wrote:
> Hi all, sorry missed the relevant CCs before.  This patch set
> adds support for exposing the firmware paths via procfs.  I've added
> an entry named /proc/fw_path which is a whitespace separated list
> of firmware paths.

Looks the paths are hard-coded in udev and mdev, which don't
export these paths to users , so I am wondering if users are interested
in the information.  But it is surely better to document the default
search paths.

Do you have some good use case about retrieving the info
at runtime?

>
> Once I have some time I hope to also send out a patch that allows
> the user to dynamically configure these paths.

IMO, kernel parameter should be an appropriate way to configure
the path, and the way of /proc or /sys may be a bit late.


Thanks,
--
Ming Lei
