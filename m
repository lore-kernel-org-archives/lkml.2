Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab2JRTlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:41:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60589 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2JRTlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:41:02 -0400
Date: Thu, 18 Oct 2012 10:24:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon fixes for Linux 3.6
Message-ID: <20121018172403.GA29562@kroah.com>
References: <50762167.8060806@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50762167.8060806@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:31:19AM +0900, Chanwoo Choi wrote:
> Hi Greg,
> 
> Please pull extcon fixes for Linux 3.6 from:
> 
>     git://git.infradead.org/users/kmpark/linux-samsung extcon-for-next
> 
> I've been creating "extcon-for-next" tree at git.infradead.org
> and rebasing the branch base on your
> driver-core.git(branch:driver-core-next).
> 
> This tree contains various small bugfixes and enhancements, fix typos.
> And extcon-max77693 initialize MUIC register during probe()
> to unmask internal interrupt of max77693 MUIC device.

Now that you have a kernel.org account, can you move this tree to
git.kernel.org, and provide me a signed tag to pull from for this set of
patches to go into 3.7?

thanks,

greg k-h
