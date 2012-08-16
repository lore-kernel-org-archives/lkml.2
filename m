Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2HPNuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:50:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55019 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab2HPNuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:50:21 -0400
Date: Thu, 16 Aug 2012 14:50:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120816135019.GS23464@ZenIV.linux.org.uk>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <20120815204546.GC25062@fieldses.org>
 <20120815210237.GF25421@moon>
 <20120815220622.GA28054@fieldses.org>
 <20120816062448.GA32081@moon>
 <20120816123814.GD1209@moon>
 <20120816134339.GQ23464@ZenIV.linux.org.uk>
 <502CF9DA.8030701@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502CF9DA.8030701@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 05:47:06PM +0400, Pavel Emelyanov wrote:
> On 08/16/2012 05:43 PM, Al Viro wrote:
> > On Thu, Aug 16, 2012 at 04:38:14PM +0400, Cyrill Gorcunov wrote:
> > 
> >> Hi Bruce, thinking a bit more I guess using general encode_fh is not that
> >> convenient since it operates with dentries while our fdinfo output deals
> >> with inodes. Thus I should either provide some new encode_fh variant
> >> which would deal with inodes directly without "parents". Which doesn't
> >> look for me anyhow better than the new export_encode_inode_fh helper.
> > 
> > Huh?  You do have dentries, for crying out loud...
> 
> Sometimes we don't -- the inotify thing gets an inode only.
> Unlike other notifies that have dentries at hands...

What's wrong with saying "we don't support idiotify"?
