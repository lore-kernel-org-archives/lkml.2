Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1AFSvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:51:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47021 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab1AFSvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:51:50 -0500
Date: Thu, 6 Jan 2011 08:20:32 -0800
From: Greg KH <gregkh@suse.de>
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace the dangerous to_root_device macro with an
 inline function
Message-ID: <20110106162032.GA10189@suse.de>
References: <44482f820e5700f952825c9b5ec6a9f080975d79.1294326889.git.wferi@niif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44482f820e5700f952825c9b5ec6a9f080975d79.1294326889.git.wferi@niif.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 04:24:24PM +0100, Ferenc Wagner wrote:
> The original macro worked only when applied to variables named 'dev'.
> While this could have been fixed by simply renaming the macro argument,
> a more type-safe replacement is preferred.

Preferred for what?  This is a local macro, not exported to anything
else, is it causing problems today within this single file?

thanks,

greg k-h
