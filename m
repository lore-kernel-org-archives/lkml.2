Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab2DFI5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:57:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34133 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2DFI5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <1333690029-4991-2-git-send-email-svenkatr@ti.com>
References: <1333690029-4991-1-git-send-email-svenkatr@ti.com>
	<1333690029-4991-2-git-send-email-svenkatr@ti.com>
Date: Fri, 6 Apr 2012 17:57:00 +0900
Message-ID: <CAKYAXd8HkMZbRZOSYqV28gi3MS+NQrKDxmWjXK=32MKVWC=_wg@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi/ufs: Fix evaluation of task_failed status
From: Namjae Jeon <linkinjeon@gmail.com>
To: Venkatraman S <svenkatr@ti.com>
Cc: linux-kernel@vger.kernel.org, Santosh Y <santoshsy@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/6 Venkatraman S <svenkatr@ti.com>:
> Else FAILED would be set even if task_result was
> originally equal to UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED.
>
> Reported-by: Joe Perches <joe@perches.com>
> Signed-off-by: Venkatraman S <svenkatr@ti.com>
> CC: Santosh Y <santoshsy@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
Good catch!!!
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
