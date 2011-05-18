Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1ERVag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:30:36 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56380 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755021Ab1ERVaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:30:35 -0400
X-Sasl-enc: FvTBheY6lK+zAwFCZpCveC2k9RzX/FFQuyqccPaUpZGD 1305754234
Date: Wed, 18 May 2011 14:17:05 -0700
From: Greg KH <greg@kroah.com>
To: anish <anish198519851985@gmail.com>
Cc: teddy.wang@siliconmotion.com.cn, linux-kernel@vger.kernel.org,
        harryxiyou@gmail.com
Subject: Re: [patch 2/3] Staging: sm7xx: preferred form for passing a size to
 memory allocation routines
Message-ID: <20110518211705.GA13555@kroah.com>
References: <1305738728.1881.84.camel@anish-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305738728.1881.84.camel@anish-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:42:08PM +0530, anish wrote:
>  The preferred form for passing a size of a struct is the following:
>          p = kmalloc(sizeof(*p), ...);
>  Please refer Documentation/Codingstyle chapter 14
> 
>  Signed-off-by: anish kumar <anish198519851985@gmail.com>
>  Acked-by: Harry Wei <harryxiyou@gmail.com>

What's with the extra spaces at the beginning of the lines?

And I never got patch 1/3 in my inbox.

You also need to put your full name in the "From:" line, like you did
for the signed-off-by: line.

So, care to try again?

thanks,

greg k-h
