Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab2DBIib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 04:38:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35297 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2DBIi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 04:38:29 -0400
Message-ID: <4F796581.1030302@openvz.org>
Date: Mon, 02 Apr 2012 12:38:25 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "drepper@gmail.com" <drepper@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F785F1D.4020503@openvz.org> <20120402010937.38b33576@pyramind.ukuu.org.uk>
In-Reply-To: <20120402010937.38b33576@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Can we add "pid" argument to be able to search next fd in other task?
>> Together with sys_kcmp() this will be very useful for checkpoint/restore.
>
> That would raise all sorts of security questions unless protected, plus
> its got races. If you want to do that and you have the rights you can do
> it via procfs anyway.

Don't worry, I just asked. =) Seems like crtools dumps fd in the target-task context,
so the current version is suitable.
