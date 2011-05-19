Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224Ab1ETEvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:51:32 -0400
Received: from ozlabs.org ([203.10.76.45]:35870 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab1ETEva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:51:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dirk Behme <dirk.behme@googlemail.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Cc: Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
In-Reply-To: <4DD3E540.8000205@googlemail.com>
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com> <1305665763-3988-1-git-send-email-abogani@kernel.org> <4DD3E540.8000205@googlemail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 19 May 2011 16:56:34 +0930
Message-ID: <8762p75exh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011 17:26:56 +0200, Dirk Behme <dirk.behme@googlemail.com> wrote:
> The old version with the warning is in linux-next now
> 
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=903996de9b35213aaa4162c24351a2cb2931d9ac

Yep, I switched to the new one after sfr's pull.

Then I switched to the enhanced-comments one just now, but if Linus was
quick to pull he'll have the undercommented version rather than the
overcommented one.

Cheers,
Rusty.

