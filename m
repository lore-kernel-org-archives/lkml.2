Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab2AOJTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 04:19:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59308 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab2AOJTl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 04:19:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120114184854.GA23282@redhat.com>
References: <1326456812.18165.0.camel@sauron.fi.intel.com>
	<20120114184854.GA23282@redhat.com>
Date: Sun, 15 Jan 2012 11:19:40 +0200
Message-ID: <CAJL_dMsugowERsv8qHuaWZB3yEstqrB3d+So-ive-EGRoi4OMg@mail.gmail.com>
Subject: Re: [PULL REQUEST] More UBI/UBIFS changes for 3.3
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Dave Jones <davej@redhat.com>,
        "Bityutskiy, Artem" <artem.bityutskiy@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 8:48 PM, Dave Jones <davej@redhat.com> wrote:

> This introduced a compile failure if CONFIG_UBIFS_FS_DEBUG is unset.
>
> fs/ubifs/journal.c: In function ‘ubifs_jnl_write_data’:
> fs/ubifs/journal.c:700:2: error: implicit declaration of function ‘dbg_jnlk’ [-Werror=implicit-function-declaration]

And now it is in Linus tree.


  CC [M]  fs/ubifs/journal.o
fs/ubifs/journal.c: In function ‘ubifs_jnl_write_data’:
fs/ubifs/journal.c:700:2: error: implicit declaration of function
‘dbg_jnlk’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[3]: *** [fs/ubifs/journal.o] Error 1
make[2]: *** [fs/ubifs] Error 2
make[1]: *** [fs] Error 2
