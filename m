Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2HNO0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:26:31 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:41204 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280Ab2HNOXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:23:07 -0400
Message-ID: <502A5F42.3080301@parallels.com>
Date: Tue, 14 Aug 2012 18:22:58 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 5/8] fs, epoll: Add procfs fdinfo helper v2
References: <20120814140342.354405844@openvz.org> <20120814140620.191720208@openvz.org>
In-Reply-To: <20120814140620.191720208@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 06:03 PM, Cyrill Gorcunov wrote:
> This allow us to print out eventpoll target file descriptor,
> events and data, the /proc/pid/fdinfo/fd consists of
> 
>  | pos:	0
>  | flags:	02
>  | tfd:        5 events:       1d data: ffffffffffffffff
> 
> This feature is CONFIG_CHECKPOINT_RESTORE only.
> 
> v2:
>  - don't walk over all rb nodes on seq-next,
>    try to continue from pervious position
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: James Bottomley <jbottomley@parallels.com>
> CC: Matthew Helsley <matt.helsley@gmail.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

