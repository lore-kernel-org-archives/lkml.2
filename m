Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966017Ab2JZSeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:34:07 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51904 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965944Ab2JZSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <20121026181323.GD25530@kroah.com>
References: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
	<20121026181323.GD25530@kroah.com>
Date: Sat, 27 Oct 2012 02:34:02 +0800
Message-ID: <CAH+=+MG3f+OsH5z-EhGM2o6eiPrugkStV2dQD+fbCWU=omZnmA@mail.gmail.com>
Subject: Re: [PATCH 1/3] debugfs: pass NULL as the last parameter of debugfs_print_regs32()
From: yan yan <clouds.yan@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/27 Greg KH <gregkh@linuxfoundation.org>:
> On Sat, Oct 27, 2012 at 01:55:42AM +0800, Yan Hong wrote:
>> Pass NULL instead of empty string to debugfs_print_regs32() when
>> prefix is not used, according to the intention of the code.
>
> Is this solving a problem?  Is it wrong as-is?  Is it causing an issue
> today?
>
> thanks,
>
> greg k-h

Hmmm ... this function is rarely used, and maybe over-designed. The
'prefix' feature can be actually removed -- nobody uses it.

As to the empty  string, it looks like a typo to me.

Thanks
