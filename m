Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab1KRQMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:12:09 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47034 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769Ab1KRQMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:12:07 -0500
X-Sasl-enc: YfSrln8cU1v2CtDG9ng5t+mAZ6ElC7repHFKYvNj95a6 1321632726
Date: Fri, 18 Nov 2011 08:11:30 -0800
From: Greg KH <greg@kroah.com>
To: Zac Storer <zac.3.14159@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Drivers: tty: synclink_gt: fixed a brace coding
 style issue
Message-ID: <20111118161130.GA30281@kroah.com>
References: <1321592069-8734-1-git-send-email-zac.3.14159@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321592069-8734-1-git-send-email-zac.3.14159@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 09:54:29PM -0700, Zac Storer wrote:
> Fixed a brace coding style issue.

Odd, I got a bunch of patches from you, starting with this one, yet each
one states it is the last in a series of patches that keeps incrementing
(i.e. 7/7, 8/8, 9/9) without the earlier patches in the series.

Also, we don't just fix one brace placement per patch, that's crazy.

Please resend all of your patches, with the correct numbering scheme,
and merge the patches where you do the same thing to the same file
together.

thanks,

greg k-h
