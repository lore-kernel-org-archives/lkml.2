Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab2K0EZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 23:25:07 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37169 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab2K0EZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 23:25:05 -0500
Date: Mon, 26 Nov 2012 20:26:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>,
        =?utf-8?B?7LWc7LCs7Jqw?= <cw00.choi@samsung.com>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "khoroshilov@ispras.ru" <khoroshilov@ispras.ru>
Subject: Re: Re: [GIT PULL] extcon for Linux 3.8
Message-ID: <20121127042631.GA17479@kroah.com>
References: <292179.45651353977670193.JavaMail.weblogic@epv6ml08>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <292179.45651353977670193.JavaMail.weblogic@epv6ml08>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 12:54:30AM +0000, MyungJoo Ham wrote:
> > On Thu, Nov 22, 2012 at 01:51:10PM +0900, MyungJoo Ham wrote:
> > > Please pull extcon patches for Linux 3.8.
> > 
> > This is not a signed-tag pull request, which I thought I asked for
> > previously.
> > 
> > Please create that, so that I can properly know I am getting the right
> > pull request and patches.
> 
> A singed tag, "pull_req_20121122", has been already attached at the HEAD
> of for-next branch.
> 
> Would it be more readable if the request is made with
> git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git tags/pull_req_20121122
> rather than
> git://git.kernel.org/pub/scm/linux/kernel/git/mzx/extcon.git for-next
> ? (both point to the same commit and I tried the first URL for git request-pull; however git request-pull gives me the second URL as the result)

git request-pull should show you the proper tag, if you are using a new
version of git (i.e. something fairly recent.)  What version of git are
you using?  How did you create the signed tag?

thanks,

greg k-h
