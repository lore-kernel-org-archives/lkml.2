Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2BARcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:32:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60928 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab2BARcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:32:03 -0500
Date: Wed, 1 Feb 2012 21:31:57 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: lp8727_chager: permission change - header file
Message-ID: <20120201173156.GA9311@oksana.dev.rtsoft.ru>
References: <B567DBAB974C0544994013492B949F8E3812CD42DD@EXMAIL03.scwf.nsc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812CD42DD@EXMAIL03.scwf.nsc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 08:00:21PM -0800, Kim, Milo wrote:
> The 'x(execute)' permission is removed.
> (chmod from 0755 to 0644)
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Applied to battery-urgent.git, thanks!

> ---
>  0 files changed, 0 insertions(+), 0 deletions(-)
>  mode change 100755 => 100644 include/linux/lp8727.h
> 
> diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
> old mode 100755
> new mode 100644
> -- 
> 1.7.4.1

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
