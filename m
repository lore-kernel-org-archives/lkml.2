Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab0KXG0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:26:47 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40797 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab0KXG0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:26:46 -0500
Date: Wed, 24 Nov 2010 15:25:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Jaya Kumar <jayalk@intworks.biz>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: arcfb: fix buffer overflow
Message-ID: <20101124062558.GF11705@linux-sh.org>
References: <1290361202-15065-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290361202-15065-1-git-send-email-segoon@openwall.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 08:40:01PM +0300, Vasiliy Kulikov wrote:
> (count + p) is not checked for integer overflow.  If p < fbmemlength
> and count == (size_t)(1 - p) (very big unsigned integer) then
> count + p == 1 < fbmemlength and copy_to_user(base_addr+p, buf, count)
> overflows base_addr.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Applied, thanks.
