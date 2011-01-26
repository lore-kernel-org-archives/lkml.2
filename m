Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1AZU2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:28:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44876 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1AZU2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:28:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=wRGjNDhqv5ugZR9j+HvBnkgwJT7T3zws6IWyfuCxey37Pc0V2ipkOkGzY7Cybu85CZ
         ExxbhfSeeOzZTWcG575apny7lfllH5+Vl7C4fVfvb26bN89Te/z+rLaWaIZKcIv8xPHE
         lmw24XNNlo8slzC1ubXQ1e2VgcYVcGwQfXSYw=
Date: Wed, 26 Jan 2011 23:28:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 7/8] staging: hv: Convert camel cased struct fields in
 vmbus_packet_format.h to lower cases
Message-ID: <20110126202826.GU2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Hank Janssen <hjanssen@microsoft.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
References: <1296064206-11372-1-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-2-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-3-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-4-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-5-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-6-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-7-git-send-email-haiyangz@microsoft.com>
 <20110126180400.GS2721@bicker>
 <A1F3067C9B68744AA19F6802BAB8FFDC02482D@TK5EX14MBXC227.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A1F3067C9B68744AA19F6802BAB8FFDC02482D@TK5EX14MBXC227.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:09:47PM +0000, Haiyang Zhang wrote:
> > 
> > 
> > These don't line up with the others.
> 
> I have corrected and resubmitted them.
> 

You could have just resubmitted the one.  Overall the patchset makes
things way better than before.  I didn't want to make more work for
you.  :/

If you're going to redo the set, it probably would have been better
to wait for a day in case anyone else says anything.  The patches
are pretty straight forward so it's doubtful that it needs changes but
it also doesn't hurt to wait.

Anyway, I diffed the two threads and it looks good.  Thanks for doing
that. 

regards,
dan carpenter

