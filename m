Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031181Ab2B2PXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:23:34 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:46348 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab2B2PXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:23:33 -0500
Message-ID: <4F4E42DB.2030507@parallels.com>
Date: Wed, 29 Feb 2012 19:23:07 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
References: <20120229151634.GE4796@moon>
In-Reply-To: <20120229151634.GE4796@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 07:16 PM, Cyrill Gorcunov wrote:
> Hi guys,
> 
> at restore time we would like to have a way for /proc/pid/exe
> symlink recovering. So I thought extending prctl might be
> a good idea.
> 
> Still maybe there some other good and 'right' way to do it,
> so I would like to gather opinions.

If using the prctl for this, then taking a given file descriptor
(with fcheck) instead of taking path and opening it in kernel is
better.

> Please review, thanks!
> 
> 	Cyrill

Thanks,
Pavel
