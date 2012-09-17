Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2IQGZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 02:25:43 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59986 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2IQGZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 02:25:42 -0400
Date: Sun, 16 Sep 2012 23:23:03 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Bryan Freed <bfreed@chromium.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, marco.stornelli@gmail.com, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v6] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
Message-ID: <20120917062302.GA768@lizard>
References: <1347042576-17675-1-git-send-email-bfreed@chromium.org>
 <20120908052907.GA4724@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120908052907.GA4724@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 10:29:10PM -0700, Anton Vorontsov wrote:
> On Fri, Sep 07, 2012 at 11:29:36AM -0700, Bryan Freed wrote:
> > When called with a non-zero of_node, fill out a new ramoops_platform_data
> > with data from the specified Flattened Device Tree node.
> > Update ramoops documentation with the new FDT interface.
> > Update devicetree/binding documentation with pstore/ramoops.txt.
> 
> Thanks for your work, Bryan! There were a few issues, I fixed
> them myself but I need your confirmation if you're OK w/ all
> the changes.
[...]
> So, the resulting patch is down below. But I have not pushed
> it out yet, I'm waiting for your sign off. If you're OK with the
> changes, please reply with
> 'Signed-off-by: Bryan Freed <bfreed@chromium.org>'

Bryan, have you had a chance to look into this?

Thanks,
Anton.
