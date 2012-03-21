Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2CUPf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:35:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61501 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2CUPfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:35:23 -0400
Date: Wed, 21 Mar 2012 08:35:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        NFS list <linux-nfs@vger.kernel.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        "Bhamare, Sachin" <sbhamare@panasas.com>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>, James Morris <jmorris@namei.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCHSET 0/4] kmod: Optional timeout on the wait in
 call_usermodehelper_exec
Message-ID: <20120321153519.GB30250@kroah.com>
References: <4F691059.30405@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F691059.30405@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 04:18:49PM -0700, Boaz Harrosh wrote:
> Andrew Hi
> 
> I'm picking on you because I don't have any one else to pick on.
> The 3 first patches here, are just good for today. Please see if
> you would like to take them? or tell me who should take them?
> 
> The 4th patch is an RFC, which got me looking into this.
> 
> My motivation is that I added yet another Kernel dependency on the
> call_usermodehelper() function and am not completely happy with the
> error case of having the user-mode program stuck forever. In such
> case I would like the Kernel part to timeout and properly error recover
> and clean up. So therefor the proposed 4th patch.

What is this new use of call_usermodhelper that you are doing this work
for?  Ideally, you never want to make this call, as it's slow and messy,
as you have found out.  Is there an in-kernel user that you have
recently added?

thanks,

greg k-h
