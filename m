Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1BJSv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:51:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1BJSv0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:51:26 -0500
Date: Thu, 10 Feb 2011 10:47:13 -0800
From: Greg KH <gregkh@suse.de>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Oren Weil <oren.jer.weil@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, david@woodhou.se,
        david.woodhouse@intel.com
Subject: Re: [RFC PATCH 00/13] Intel(R) MEI Driver
Message-ID: <20110210184713.GA15882@suse.de>
References: <0d30dc$l1diqi@orsmga001.jf.intel.com>
 <20110210175855.GC13795@suse.de>
 <AANLkTimyxSy2FDBjh-xR1XmuZ9c7KjYHN-CjFAfp4Eu_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimyxSy2FDBjh-xR1XmuZ9c7KjYHN-CjFAfp4Eu_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 08:43:57PM +0200, Tomas Winkler wrote:
> On Thu, Feb 10, 2011 at 7:58 PM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Feb 10, 2011 at 01:54:54AM -0800, Oren Weil wrote:
> >> Intel(R) Management Engine Interface (Intel(R) MEI) Driver
> >> ==========================================================
> >>
> >> This patch contains a new Intel driver for the Linux kernel: The Intel(R) MEI Driver.
> >
> > This patch?  What patch, there is no patch here.
> >
> > You sent out 13 emails with the same exact Subject line, which is not
> > acceptable at all, and mighty confusing.
> >
> >> This set of patches is for review purposes; the driver code
> >> for pull is in the David Woodhouse public git repository:
> >> http://git.infradead.org/linux-2.6-mei.git
> >
> > No, we need these as patches, not as a pull request.  Please work on
> > fixing up your individual patches, that's the only way this is going to
> > be accepted.
> 
> There was a suggestion of splitting the driver into per file patches
> to be reviewable  rather then creating gigantic driver patch.
> I personally would prefer the later one  would happy to here any other
> suggestions how to split driver.

Per-file is ok, but just provide proper documentation, don't break the
build, and do it the correct way, like everyone else does every day.
This isn't something new people...

greg k-h
