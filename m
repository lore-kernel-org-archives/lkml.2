Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2BYEBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 23:01:17 -0500
Received: from ozlabs.org ([203.10.76.45]:57773 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab2BYEBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 23:01:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andreas =?utf-8?Q?Bie=C3=9Fmann?= <andreas@biessmann.de>,
        linux-kernel@vger.kernel.org
Cc: Andreas =?utf-8?Q?Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jochen Friedrich <jochen@scram.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: Re: [PATCH v2] mod/file2alias: make modpost compile on darwin again
In-Reply-To: <1330068233-12713-1-git-send-email-andreas@biessmann.de>
References: <1329947735-4331-1-git-send-email-andreas@biessmann.de> <1330068233-12713-1-git-send-email-andreas@biessmann.de>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 25 Feb 2012 14:21:45 +1030
Message-ID: <87zkc736zy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012 08:23:53 +0100, Andreas Bießmann <andreas@biessmann.de> wrote:
> commit e49ce14150c64b29a8dd211df785576fa19a9858 breaks cross compiling
> the linux kernel on darwin hosts.
> This fix introduce some minimal glue to adopt linker section handling
> for darwin hosts.

Thanks, applied.

Rusty.
