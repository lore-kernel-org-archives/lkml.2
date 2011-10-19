Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab1JSXVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:21:49 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50496 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753511Ab1JSXVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:21:48 -0400
X-Sasl-enc: 0gZ/d7JhIbJ64lcnh7eL6lNVnFlsBxrsYwcHgiwRzJyy 1319066507
Date: Wed, 19 Oct 2011 16:17:16 -0700
From: Greg KH <greg@kroah.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] Resend previous incorrecly formatted patches
Message-ID: <20111019231716.GA10113@kroah.com>
References: <1319065048-2767-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319065048-2767-1-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 11:57:09PM +0100, Mark Einon wrote:
> Resending patches, these have now been formatted with:
> 
> git format-patch -k -M
> 
> Tested with git am sucessfully on a local tree

But when you sent them, they did not have any [xx/yy] markings on them
so I have no idea what order to apply them in.

Did you use git send-email to send these?  If not, why not?

We'll get this right one of these tries :)

greg k-h
