Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab0LTQAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:00:44 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57735 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078Ab0LTQAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:00:42 -0500
Date: Tue, 21 Dec 2010 00:59:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andres Salomon <dilinger@queued.net>
Cc: akpm@linux-foundation.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s1d13xxxfb: drop unused code
Message-ID: <20101220155912.GC26766@linux-sh.org>
References: <20101217190013.0107a93a@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217190013.0107a93a@queued.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 07:00:13PM -0800, Andres Salomon wrote:
> 
> Silence warnings such as -
> 
> drivers/video/s1d13xxxfb.c:421: warning: ???bltbit_wait_bitset??? defined but not used
> 
> Just drop the unused code.
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>

Applied, thanks.
