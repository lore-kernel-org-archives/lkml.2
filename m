Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab2JVWyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:54:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58974 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab2JVWyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:54:32 -0400
Date: Mon, 22 Oct 2012 15:54:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: Re: [PATCHv3 3/6] staging: rts_pstor: reuse kbasename()
Message-ID: <20121022225428.GA3479@kroah.com>
References: <1350388094-18805-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1350388094-18805-5-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350388094-18805-5-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 02:48:11PM +0300, Andy Shevchenko wrote:
> The custom filename function mostly repeats the kernel's kbasename. This patch
> simplifies it. The updated filename() will not check for the '\' in the
> filenames. It seems redundant in Linux. The __FILE__ macro always defined if
> we compile an existing file. Thus, NULL check is not needed there as well.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

