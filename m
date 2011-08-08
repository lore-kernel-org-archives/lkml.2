Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab1HHJsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:48:20 -0400
Received: from lo.gmane.org ([80.91.229.12]:51737 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1HHJsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:48:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: Compile kernel for various times and problem of too long time
 consuming
Date: Mon, 8 Aug 2011 09:48:05 +0000 (UTC)
Message-ID: <j1obck$554$1@dough.gmane.org>
References: <CAC-yRPQS7r-MMh13Y1m0O+oLBu2OmQqmXS8iHFtCOS9YwrxrkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 14.205.14.50
User-Agent: Pan/0.133 (House of Butterflies)
Cc: kernelnewbies@kernelnewbies.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Aug 2011 21:39:12 +0430, Amirali Shambayati wrote:

> Hi all,
> Since I want to evaluate performance improvements by changing just one
> file in kernel(noop-iosched) and compiling kernel is too much
> time-consuming, I want to know that if I compile kernel for more than
> one time, does it take similar time to first time?
> 
> I use following commands. If I don't use "make-kpkg clean" for next
> times, does it just compile the files which have been modified or it
> compile whole kernel package again?
> 
> make-kpkg clean
> fakeroot make-kpkg --initrd --append-to-version=-some-string-here
> kernel-image kernel-headers

Don't run 'make-kpkg clean', and try to use ccache,
make CC='ccache gcc'

