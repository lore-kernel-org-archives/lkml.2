Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab2DFIxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:53:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57568 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2DFIxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:53:17 -0400
MIME-Version: 1.0
In-Reply-To: <1333690029-4991-1-git-send-email-svenkatr@ti.com>
References: <1333690029-4991-1-git-send-email-svenkatr@ti.com>
Date: Fri, 6 Apr 2012 17:53:16 +0900
Message-ID: <CAKYAXd8Lu+UnJQ=HQ4jXt-D2pBTerKDjbQ7=2WHJCsxiGtQKnw@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi/ufs: reverse the ufshcd_is_device_present logic
From: Namjae Jeon <linkinjeon@gmail.com>
To: Venkatraman S <svenkatr@ti.com>
Cc: linux-kernel@vger.kernel.org, Santosh Y <santoshsy@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/6 Venkatraman S <svenkatr@ti.com>:
>  Otherwise it counter intuitively returns 0 if device is present.
>
> Signed-off-by: Venkatraman S <svenkatr@ti.com>
> CC: Santosh Y <santoshsy@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
This patch make sense.
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>

> ---
