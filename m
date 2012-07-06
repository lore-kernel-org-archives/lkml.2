Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab2GFXQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 19:16:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35752 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932665Ab2GFXQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 19:16:12 -0400
X-Sasl-enc: f4TeipmCtentQCcxJZjKXyPesOrIZpQy451r/qD6hlz7 1341616571
Date: Fri, 6 Jul 2012 16:16:10 -0700
From: Greg KH <greg@kroah.com>
To: Pablo =?iso-8859-1?Q?V=E1zquez?= <peibolvigo@gmail.com>
Cc: swetland@google.com, john.stultz@linaro.org, arve@android.com,
        ccross@android.com, bringert@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: fix pr_info and pr_err coding style
 issues in ashmem.c
Message-ID: <20120706231610.GA32561@kroah.com>
References: <1340987232-25169-1-git-send-email-peibolvigo@gmail.com>
 <CAJ6TP82bM4d+pAc-+w_Y934FgBz5sQoyHm118s39GH5tf3TkJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ6TP82bM4d+pAc-+w_Y934FgBz5sQoyHm118s39GH5tf3TkJA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 07:48:45PM +0200, Pablo Vázquez wrote:
> Ok, added the #define pr_fmt(fmt) ...

You sent this in HTML format, makeing it impossible to apply :(

Care to try it again?

thanks,

greg k-h
