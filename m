Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab1EQXYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 19:24:15 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36710 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932561Ab1EQXYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 19:24:14 -0400
X-Sasl-enc: DlslRhlgMmGEtdoJp8IdkdzBXnRGqHAPouMQxtHi8LL/ 1305674653
Date: Tue, 17 May 2011 16:22:41 -0700
From: Greg KH <greg@kroah.com>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dirk Behme <dirk.behme@googlemail.com>
Subject: Re: [PATCH] module: Use binary search in lookup_symbol()
Message-ID: <20110517232241.GA19140@kroah.com>
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com>
 <1305665763-3988-1-git-send-email-abogani@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305665763-3988-1-git-send-email-abogani@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 10:56:03PM +0200, Alessio Igor Bogani wrote:
> This work was supported by a hardware donation from the CE Linux Forum.
> 
> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
> ---

That's nice, but _why_ do this change?  What does it buy us?

Please explain why you make a change, not just who sponsored the change,
that's not very interesting to developers.

thanks,

greg k-h
