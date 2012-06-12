Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab2FLRzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:55:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38197 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2FLRzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:55:13 -0400
Date: Tue, 12 Jun 2012 10:55:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Javier =?iso-8859-1?Q?Mu=F1oz?= <jmunhoz@igalia.com>
Cc: teddy.wang@siliconmotion.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: sm7xxfb: sm7xx becomes sm7xxfb
Message-ID: <20120612175506.GA27756@kroah.com>
References: <1339326744-17507-1-git-send-email-jmunhoz@igalia.com>
 <1339326744-17507-4-git-send-email-jmunhoz@igalia.com>
 <4FD4843F.6070602@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FD4843F.6070602@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 01:25:51PM +0200, Javier Muñoz wrote:
> On 06/10/2012 01:12 PM, Javier M. Mellid wrote:
> > From: "Javier M. Mellid" <jmunhoz@igalia.com>
> > 
> > Rename sm7xx driver to sm7xxfb. Fix Kconfig and Makefile to fit the new
> > change.
> > 
> > Changes are coherent with the rest of stable framebuffer drivers. TODO
> > updated.
> 
> Just one doubt. I am using 'git mv' here and it works Ok. 'git log
> --follow' would be the way to see the whole history after this commit.
> Should I follow another approach? I am using a 'similar approach' to
> ed16648eb5b86917f0b90bdcdbc857202da72f90 commit to rename.
> 
> Please, let me know if I should redo this patch.

When I apply it, git will detect the file being moved.

Also, patch, and git, now support renames when generating patches, you
should use that and it will be a bit more obvious that this really is
just a rename.

thanks,

greg k-h
