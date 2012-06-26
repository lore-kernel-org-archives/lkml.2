Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2FZXof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:44:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58490 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab2FZXoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:44:34 -0400
Date: Tue, 26 Jun 2012 16:44:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 00/13] drivers: hv: kvp
Message-ID: <20120626234430.GA17907@kroah.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
 <20120621224737.GA5933@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155EC47A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120622132547.GA2639@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED14D@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626213954.GA4840@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED64A@SN2PRD0310MB382.namprd03.prod.outlook.com>
 <20120626222205.GA5948@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF9155ED68D@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF9155ED68D@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 10:28:48PM +0000, KY Srinivasan wrote:
> > The fact that it was Red Hat specific was the main part, this should be
> > done in a standard way, with standard tools, right?
> 
> The reason I asked this question was to make sure I address these
> issues in addition to whatever I am debugging now. I use the standard
> tools and calls to retrieve all the IP configuration. As I look at
> each distribution the files they keep persistent IP configuration
> Information is different and that is the reason I chose to start with
> RedHat. If there is a standard way to store the configuration, I will
> do that.

You shouldn't be looking at any files, but rather calling programs to
get the information.  Think about systems with NetworkManager, and not
just the older Red Hat static scripts?  What about Gentoo and Ubuntu and
Arch and LFS and Slackware and SLES and Fedora?  You are quickly going
to go crazy if you are going to be mucking around looking in files for
things.

What exactly are you trying to do here?  That might be the better place
to start with instead of the implementation you have created.

thanks,

greg k-h
