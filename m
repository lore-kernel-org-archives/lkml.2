Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1K3IeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:34:14 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46554 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751774Ab1K3IeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:34:13 -0500
Message-ID: <1322642051.2123.11.camel@Joe-Laptop>
Subject: Re: [PATCH 16/28] namespace: checkpatch wanking
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 30 Nov 2011 00:34:11 -0800
In-Reply-To: <20111130065014.GU2203@ZenIV.linux.org.uk>
References: <cover.1322609672.git.joe@perches.com>
	 <a3527806b3af190204da9de1df1bfe4421ed6101.1322609673.git.joe@perches.com>
	 <20111130022245.GS2203@ZenIV.linux.org.uk>
	 <1322624351.17214.5.camel@Joe-Laptop>
	 <20111130065014.GU2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 06:50 +0000, Al Viro wrote:
> -	if (!(page = __get_free_page(GFP_KERNEL)))
> +	page = __get_free_page(GFP_KERNEL);
> +	if (!page)
>  		return -ENOMEM;
> Not sure...  In general I'd agree, but in this case...

Shrug.  I'm not sure there's much of a case other than
line count for keeping this a one-liner.

If you want these sorts of changes to be redone after
vfsmount-guts gets promoted, let me know.

