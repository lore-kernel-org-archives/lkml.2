Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1LHTYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 14:24:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52645 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1LHTYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 14:24:45 -0500
Date: Thu, 8 Dec 2011 23:21:43 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Hugh Dickins <hughd@google.com>
Cc: kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg KH <greg@kroah.com>, Theodore Tso <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC v2 2/3] procfs: add hidepid= and gid= mount options
Message-ID: <20111208192143.GB9794@albatros>
References: <20111119110126.GA11468@albatros>
 <20111119110212.GB11468@albatros>
 <alpine.LSU.2.00.1112051451470.3938@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1112051451470.3938@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Mon, Dec 05, 2011 at 14:55 -0800, Hugh Dickins wrote:
> On Sat, 19 Nov 2011, Vasiliy Kulikov wrote:
> > This patch adds support of mount options to restrict access to
> > /proc/PID/ directories.  The default backward-compatible "relaxed"
> > behaviour is left untouched.
> 
> This patch, in 3.2.0-rc3-next-20111202, leaks tasks: watch
> while :; do ps; grep KernelStack /proc/meminfo; sleep 1; done

Thank you very much for the report!

Unfortunately, I have no time to look at it now, will try to debug the
issue these weekends.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
