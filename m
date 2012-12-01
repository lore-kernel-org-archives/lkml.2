Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab2LAQuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:50:32 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:38431 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2LAQub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:50:31 -0500
Date: Sat, 1 Dec 2012 08:50:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/54] 3.6.9-stable review
Message-ID: <20121201165027.GE3113@kroah.com>
References: <20121130185207.894301294@linuxfoundation.org>
 <87txs5u8dn.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txs5u8dn.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 11:58:28PM +0900, Satoru Takeuchi wrote:
> At Fri, 30 Nov 2012 10:55:31 -0800,
> Greg Kroah-Hartman wrote:
> > 
> > This is the start of the stable review cycle for the 3.6.9 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun Dec  2 18:51:00 UTC 2012.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.9-rc1.gz
> > and the diffstat can be found below.
> 
> 3.6.9-rc1 can be built and boot without any problem. Building a kernel with
> this kernel also works fine.

Great, thanks for testing all three of these trees out and letting me
know.

greg k-h
