Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab1J2EuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 00:50:09 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:41165 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980Ab1J2EuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 00:50:07 -0400
X-Sasl-enc: cAmoW4vBj3V98V30i7bc53u4iuZ5nQXhYNvaRez+3BGs 1319863806
Date: Sat, 29 Oct 2011 06:49:52 +0200
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, joe@perches.com,
        dmitry.torokhov@gmail.com, jkosina@suse.cz
Subject: Re: [PATCH 0/3] Staging: hv: mousevsc: cleanup the mouse driver
Message-ID: <20111029044952.GA1061@kroah.com>
References: <1319839847-28959-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319839847-28959-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 03:10:47PM -0700, K. Y. Srinivasan wrote:
> Further cleanup to move the mouse driver out of staging. 
> This patch-set addresses the comments I have  received from Jiri, Joe and Greg.
> Thank you for taking the time to review the code.

Please note, all of this work is too late for the 3.2 merge, as it
needed to be completed weeks ago for that to happen.  And, as we are in
the middle of the merge, our time allocated to reviewing new patches is
quite limited.

So you might have a lot better success in just waiting a few weeks so
that we then have the time to review and address all of these cleanup
patches and requests to move the hyperv drivers.

I know I'm not going to be accepting any such patches from anyone other
than pure-bugfixes for the next 2-3 weeks at the least.

thanks,

greg k-h
