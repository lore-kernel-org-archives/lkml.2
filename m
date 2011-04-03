Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab1DCXoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 19:44:10 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59765 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1DCXoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 19:44:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qs+qqd4RGUjsszUozFzNNvosGtn4ltORsrDbwePAr6CBhjDUe88qrAUFsE5fYTbjxc
         ad1LW13z2Zwq5nDTYh8en9BlqYO831njwUvUV1q+tEyu2nJ5Smnaz6nL9h47ggyMZ2IK
         /5GHApvRoW0gJrf1aiUaJI3qrcszWiV5Gm94Y=
Date: Sun, 3 Apr 2011 16:44:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2 v2] percpu: unify input section names
Message-ID: <20110403234402.GC1420@mtj.dyndns.org>
References: <1301601122-25431-1-git-send-email-vapier@gentoo.org>
 <1301696134-31249-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301696134-31249-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 06:15:34PM -0400, Mike Frysinger wrote:
> The two percpu helper macros have the section names duplicated.  So create
> a new define to merge the two.  This also allows arches who need to link
> things more directly themselves to avoid duplicating the input sections in
> their linker script.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied to percpu#fixes-2.6.39.  I'll push the branch to Linus
soonish.  It is a stable branch so please feel free to pull from it if
necessary.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git fixes-2.6.39

Thanks.

-- 
tejun
