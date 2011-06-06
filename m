Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab1FFVWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:22:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38704 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab1FFVWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:22:12 -0400
Date: Mon, 6 Jun 2011 22:22:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] seq_file.h: introduce DECLARE_SEQ_FOPS_{RO,RW}
Message-ID: <20110606212209.GM11521@ZenIV.linux.org.uk>
References: <201106061319.45855.hartleys@visionengravers.com>
 <20110606210755.GL11521@ZenIV.linux.org.uk>
 <ADE657CA350FB648AAC2C43247A983F001F3820B7C57@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3820B7C57@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 04:19:15PM -0500, H Hartley Sweeten wrote:
> On Monday, June 06, 2011 2:08 PM, Al Viro wrote:
> > On Mon, Jun 06, 2011 at 01:19:45PM -0700, H Hartley Sweeten wrote:
> >> Many of the procfs and debugfs attribute file_operations in the kernel are
> >> missing the .owner information. Introduce some macro's to fill in the .owner
> >> field as well as the common methods for virtual file file_operations.  This
> >> simplifies creating the attributes and makes sure all the fields are properly
> >> initialized.
> >> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >
> > Nacked-by: Al Viro <viro@zeniv.linux.org.uk>
> > Nacked-because: too ugly
> >
> > Don't play that kind of games with preprocessor.
> 
> Just an FYI, the exact same thing is being done with DEFINE_SIMPLE_ATTRIBUTE
> in fs.h:

Yes, and DEFINE_SIMPLE_ATTRIBUTE is sick and ugly.
