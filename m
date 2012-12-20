Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2LTF3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:29:18 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:57626 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab2LTF3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:29:08 -0500
Date: Wed, 19 Dec 2012 21:32:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: User Linux <user.kernel@gmail.com>
Cc: "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: Kernel 3.7.1 bug: include/uapi/linux/usb/ch9.h
Message-ID: <20121220053205.GA28007@kroah.com>
References: <CAFO3HzWnbZ+=BfF35kc1c3xQ6EUuRdri5_p14YJ_Ws17u6bMWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFO3HzWnbZ+=BfF35kc1c3xQ6EUuRdri5_p14YJ_Ws17u6bMWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 07:32:18PM -0800, User Linux wrote:
> Updated from kernel 3.6.10 to 3.7.1 and encountered the following when
> recompiling media_build dvb drivers:
> 
> include/uapi/linux/usb/ch9.h:597:77: error: expected declaration
> specifiers or '...' before '(' token

How exactly did you get this error?  What are you building, an
out-of-tree driver, or the "normal" kernel build?

Can you please send the full output of what you are seeing?

thanks,

greg k-h
