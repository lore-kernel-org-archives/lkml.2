Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2BXEIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 23:08:07 -0500
Received: from ozlabs.org ([203.10.76.45]:58979 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab2BXEIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 23:08:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andreas =?utf-8?Q?Bie=C3=9Fmann?= <andreas@biessmann.de>
Cc: Andreas =?utf-8?Q?Bie=C3=9Fmann?= <andreas@biessmann.de>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jochen Friedrich <jochen@scram.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH] mod/file2alias: make modpost compile on darwin again
In-Reply-To: <4F45DC99.1050405@biessmann.de>
References: <1329947735-4331-1-git-send-email-andreas@biessmann.de> <874nui5uv2.fsf@rustcorp.com.au> <4F45DC99.1050405@biessmann.de>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 24 Feb 2012 14:34:59 +1030
Message-ID: <877gzc511w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 07:28:41 +0100, Andreas Bießmann <andreas@biessmann.de> wrote:
> > Oh, and checkpatch.pl is wrong, the code was fine.
> 
> Sorry for that. I was running checkpatch.pl as dutiful patch submitter
> and that complained.

In the Olden Days, we could easily spot code which needed auditing
simply by looking at the (lack of) coding style.  But then someone
decided that the most important attribute of good code was the nature of
the whitespace within it.  And they wrote a tool.

For a while, this made it really hard for us maintainers to tell which
incoming patches we should actually read!  Fortunately, the
Anti-whitespace crusaders have come full circle: we can now tell newbie
coders by the fact that they obey checkpatch.pl.

> Should I provide another version with 'checkpatch' adoptions changed
> back?

Please :)

Thanks,
Rusty.
