Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2JOQo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:44:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62672 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2JOQoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:44:25 -0400
Date: Mon, 15 Oct 2012 09:41:30 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: dragos.tatulea@intel.com
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        octavian.purdila@intel.com
Subject: Re: [PATCH 0/8] pstore: add interface for dumpers and add task list
 dumper
Message-ID: <20121015164130.GA12599@lizard>
References: <1350301137-16912-1-git-send-email-dragos.tatulea@intel.com>
 <20121015163913.GA10981@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121015163913.GA10981@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 09:39:13AM -0700, Anton Vorontsov wrote:
> Hi Dragos,
> 
> On Mon, Oct 15, 2012 at 02:38:49PM +0300, dragos.tatulea@intel.com wrote:
> > From: Dragos Tatulea <dragos.tatulea@intel.com>
> > 
> > This patchset adds an interface for registering various clients (dumpers)
> > that can save info into pstore at crash time.
> > 
> > Such a dumper is added which does task list dumping.
> 
> The patches are damaged. Message headers says that you used
> git-send-email, so I'd guess the mail server is doing something weird...

OK, I see the new series...

> Also, please add Colin Cross <ccross@android.com>, Kees Cook
> <keescook@chromium.org> and Tony Luck <tony.luck@intel.com> to the Cc:
> list on the next resend.
