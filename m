Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab2DZSW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:22:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab2DZSW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:22:56 -0400
Date: Thu, 26 Apr 2012 14:22:54 -0400
From: Josef Bacik <josef@redhat.com>
To: Jim Meyering <jim@meyering.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: NUL-terminate path buffer in DEV_INFO ioctl result
Message-ID: <20120426182253.GB1890@localhost.localdomain>
References: <87pqauwitz.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqauwitz.fsf@rho.meyering.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 06:36:56PM +0200, Jim Meyering wrote:
> 
> A device with name of length BTRFS_DEVICE_PATH_NAME_MAX or longer
> would not be NUL-terminated in the DEV_INFO ioctl result buffer.
> 
> Signed-off-by: Jim Meyering <meyering@redhat.com>

Reviewed-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef
