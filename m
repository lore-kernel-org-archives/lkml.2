Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab1BKWxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:53:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44380 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072Ab1BKWxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:53:44 -0500
Date: Fri, 11 Feb 2011 14:53:31 -0800
From: Greg KH <gregkh@suse.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH]: Staging: hv: Cleanup vmalloc calls
Message-ID: <20110211225331.GA32412@suse.de>
References: <1297464525-23254-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297464525-23254-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 02:48:45PM -0800, K. Y. Srinivasan wrote:
> The subject says it all. There is no need to
> specify different page protection bits based
> on the architecture.

Wonderful, thanks for doing this.  I'll queue it up after your previous
patches sometime next week.

thanks,

greg k-h
