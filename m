Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab2IETNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:13:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2IETNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:13:53 -0400
Date: Wed, 5 Sep 2012 12:11:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, ben@decadent.org.uk, thozza@redhat.com,
        dcbw@redhat.com
Subject: Re: [PATCH 0/4] Tools: hv
Message-ID: <20120905191119.GA2085@kroah.com>
References: <1346864519-30020-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346864519-30020-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 10:01:59AM -0700, K. Y. Srinivasan wrote:
> This patchset was authored by Ben Hutchings <ben@decadent.org.uk>. Ben
> asked me to submit this patchset. This patchset cleans up the KVP daemon
> code and fixes some bugs.
> 
> 
> K. Y. Srinivasan (4):
>   tools: hv: Fix file handle leak
>   tools: hv: Fix exit() error code
>   tools: hv: Check for read/write errors
>   tools: hv: Parse /etc/os-release

If Ben wrote these, why are you showing that you wrote them?

Please ALWAYS keep the proper authorship information on ALL patches.  To
not do so is rude and problematic on on so many different levels.

Fix this up and resend please.

greg k-h
