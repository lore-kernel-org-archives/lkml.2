Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab1CAFqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:46:39 -0500
Received: from kroah.org ([198.145.64.141]:43593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab1CAFq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:46:27 -0500
Date: Mon, 28 Feb 2011 18:58:59 -0800
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH 6/6] Staging: hv: Cleanup hyperv_driver variable names
Message-ID: <20110301025859.GG1663@kroah.com>
References: <1298686078-30945-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298686078-30945-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 06:07:58PM -0800, K. Y. Srinivasan wrote:
> The title says it all.

That's a horrible changelog comment.  So bad that I would rather see an
empty message than this one.  Seriously, it give no description, and
makes us think that the whole patch is obvious, when it really isn't.

What did you change them to?
What did you change them from?
What was your motivation in changing them?
How were you feeling when the names changed?

Ok, maybe not the last one, but you get the idea.

thanks,

greg k-h
