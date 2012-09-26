Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2I0CFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:05:44 -0400
Received: from ozlabs.org ([203.10.76.45]:50031 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab2I0CFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:05:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Amit Shah <amit.shah@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "sjurbren\@gmail.com" <sjurbren@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "yrl.pp-manager.tt\@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: RE: [PATCH 1/3] virtio_console:Merge struct buffer_token into struct port_buffer
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057923BD8365F7@EXDCVYMBSTM005.EQ1STM.local>
References: <1348580837-10919-1-git-send-email-sjur.brandeland@stericsson.com> <1348580837-10919-2-git-send-email-sjur.brandeland@stericsson.com> <50626C11.9040708@hitachi.com> <81C3A93C17462B4BBD7E272753C1057923BD8365F7@EXDCVYMBSTM005.EQ1STM.local>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 27 Sep 2012 09:12:33 +0930
Message-ID: <87k3vg4ahi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sjur BRENDELAND <sjur.brandeland@stericsson.com> writes:
>> This allocates one redundant sg entry when nrbuf > 0,
>> but I think it is OK. (just a comment)
>
> I did this on purpose for the sake of simplicity, but I can
> change this to something like:
> 	 alloc_size = sizeof(*buf) + sizeof(buf->sg) * max(nrbufs - 1, 1);

That's why we use [0] in the definition (a GCC extension).

Cheers,
Rusty.
