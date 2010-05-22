Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0EVIck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 04:32:40 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:51857 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab0EVIch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 04:32:37 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de, hooanon05@yahoo.co.jp,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V11 1/9] exportfs: Return the minimum required handle size
In-Reply-To: <20100521221516.GD13227@fieldses.org>
References: <1274340938-29628-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1274340938-29628-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100521221516.GD13227@fieldses.org>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sat, 22 May 2010 14:02:23 +0530
Message-ID: <874oi02v6w.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 18:15:16 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> On Thu, May 20, 2010 at 01:05:30PM +0530, Aneesh Kumar K.V wrote:
> > The exportfs encode handle function should return the minimum required
> > handle size. This helps user to find out the handle size by passing 0
> > handle size in the first step and then redoing to the call again with
> > the returned handle size value.
> 
> The encode_fh() interface is a little confusing.  (Not your fault,
> really, mainly it's the return value (and the special use of 255) that I
> always find odd.)
> 
> But maybe it would help to have a little more documention in the
> export_encode_fh() kerneldoc comment and/or in
> Documentation/filesystems/nfs/Exporting?
> 


Will update in the next iteration.

-aneesh
