Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1CKXDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 18:03:42 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:54221 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab1CKXDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 18:03:41 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 12 Mar 2011 00:06:01 +0100
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Fix computing srcversion for modules
Message-ID: <20110311230601.GA1559@polaris.bitmath.org>
References: <20110311092811.GA2079@polaris.bitmath.org>
 <1299879287-30889-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299879287-30889-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PyBMV-0001zw-6K.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PyBMV-0001zw-6K 6d8bcd5564aa6d06373c29ccb540296e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 10:34:47PM +0100, Michal Marek wrote:
> Recent change to fixdep:
> 
>     commit b7bd182176960fdd139486cadb9962b39f8a2b50
>     Author: Michal Marek <mmarek@suse.cz>
>     Date:   Thu Feb 17 15:13:54 2011 +0100
> 
>     fixdep: Do not record dependency on the source file itself
> 
> changed the format of the *.cmd files without realizing that it is also
> used by modpost. Put the path to the source file to the file back, in a
> special variable, so that modpost sees all source files when calculating
> srcversion for modules.
> 
> Reported-by: Henrik Rydberg <rydberg@euromail.se>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---

Solves the problem, and the patch looks reasonable.

Tested-by: Henrik Rydberg <rydberg@euromail.se>

Thanks!
Henrik
