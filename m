Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab2HQPtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:49:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab2HQPtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:49:03 -0400
Date: Fri, 17 Aug 2012 12:48:58 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <huewe.external.infineon@googlemail.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [v2.6.34-stable 050/165] TPM: Zero buffer after copying to
 userspace
Message-ID: <20120817154857.GD4039@herton-Z68MA-D2H-B3>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
 <1345060109-9187-51-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345060109-9187-51-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:46:34PM -0400, Paul Gortmaker wrote:
> From: Peter Huewe <huewe.external.infineon@googlemail.com>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit 3321c07ae5068568cd61ac9f4ba749006a7185c9 upstream.
> 
> Since the buffer might contain security related data it might be a good idea to
> zero the buffer after we have copied it to userspace.
> 
> This got assigned CVE-2011-1162.
> 
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> Signed-off-by: James Morris <jmorris@namei.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
[...]

commit 3ab1aff89477dafb1aaeafe8c8669114a02b7226 ("TPM: Zero buffer whole
after copying to userspace") is something to consider to be applied
after this, either with this update or later 2.6.34 update. It
complements this change, just fyi.

-- 
[]'s
Herton
