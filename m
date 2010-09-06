Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0IFUuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 16:50:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab0IFUuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 16:50:10 -0400
Date: Mon, 6 Sep 2010 13:33:30 -0700
From: Greg KH <gregkh@suse.de>
To: walter harms <wharms@bfs.de>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        David Cross <david.cross@cypress.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] staging: westbridge: improve error path
Message-ID: <20100906203330.GE5162@suse.de>
References: <1283711573-7460-1-git-send-email-segooon@gmail.com> <4C849D78.9040202@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C849D78.9040202@bfs.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 09:51:20AM +0200, walter harms wrote:
> the indention should be fixed also.

Yes, the indentation for the whole file should be fixed, but that's not
what this patch was doing.

Remember, a patch should only do one thing at a time.

thanks,

greg k-h
