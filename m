Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab2HNOX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:23:57 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9166 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab2HNOXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:23:54 -0400
Message-ID: <502A5F70.3010607@parallels.com>
Date: Tue, 14 Aug 2012 18:23:44 +0400
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
Subject: Re: [patch 7/8] fs, notify: Add procfs fdinfo helper v3
References: <20120814140342.354405844@openvz.org> <20120814140620.374705810@openvz.org>
In-Reply-To: <20120814140620.374705810@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2012 06:03 PM, Cyrill Gorcunov wrote:
> This allow us to print out fsnotify details such as
> watchee inode, device, mask and file handle.
> 
> For example for inotify objects the output is
> 
>  | pos: 0
>  | flags:       02000000
>  | inotify wd:        3 ino:             9e7e sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 7e9e0000640d1b6d
>  | inotify wd:        2 ino:             a111 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 11a1000020542153
>  | inotify wd:        1 ino:            6b149 sdev:   800013 mask:  800afce ignored_mask:        0 fhandle-bytes:        8 fhandle-type:        1 f_handle: 49b1060023552153
> 
> For fanotify it is like
> 
>  | pos: 0
>  | flags:       02
>  | fanotify ino:            68f71 sdev:   800013 mask:        1 ignored_mask: 40000000 fhandle-bytes:        8 fhandle-type:        1 f_handle: 718f0600b9f42053
>  | fanotify mnt_id:       13 mask:        1 ignored_mask: 40000000
> 
> This feature is CONFIG_CHECKPOINT_RESTORE only. To minimize
> impact on general fsnotify code the new functionality is gathered
> in fs/notify/fdinfo.c file mostly.
> 
> v2:
>  - append missing colons to terms
> v3:
>  - continue from pervious position in list on ->next
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Al Viro <viro@ZenIV.linux.org.uk>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: James Bottomley <jbottomley@parallels.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>

