Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2LZSmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 13:42:33 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:52791 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2LZSmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 13:42:31 -0500
Message-ID: <50DB4514.6090706@tilera.com>
Date: Wed, 26 Dec 2012 13:42:28 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Simon Marchi <simon.marchi@polymtl.ca>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] arch/tile: Call tracehook_report_syscall_{entry,exit}
 in syscall trace
References: <1356153672-17545-1-git-send-email-simon.marchi@polymtl.ca>
In-Reply-To: <1356153672-17545-1-git-send-email-simon.marchi@polymtl.ca>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 12:21 AM, Simon Marchi wrote:
> Call tracehook functions for syscall tracing.
>
> The check for TIF_SYSCALL_TRACE was removed, because the same check is
> done right before in the assembly file.
>
> Signed-off-by: Simon Marchi <simon.marchi@polymtl.ca>
>

I've taken this one, and patch 3/3 in this series, into the tile tree (and pushed it up to linux-next).  I fixed up ptrace.h to adjust the declarations for the modified functions.

As Al Viro pointed out, patch 2/3 is already present in v3.8-rc1.

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

