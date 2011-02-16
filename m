Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965Ab1BPQXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:23:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36884 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab1BPQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:23:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DofIy18gO1PwGGW9OVQLZSIZ1gozuXXhnz/N7EQ3TfdeyCROZcpHQe3F55u8Vc6Tr6
         vxP7FeICCX8slVfNuPAJQDSPUagNVnXKBp4UqbxIRFV9XYJMuZ9OsknVRJgYJnnqTcwd
         Mdt/DYrf6t/CJ1dKQjHa6jiZ70tlyFOc8nPb0=
Date: Wed, 16 Feb 2011 17:23:29 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA
 config/emulation
Message-ID: <20110216162329.GI19830@htj.dyndns.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
 <20110216125249.GA18113@elte.hu>
 <20110216141757.GG19830@htj.dyndns.org>
 <20110216155314.GA22855@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216155314.GA22855@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 04:53:14PM +0100, Ingo Molnar wrote:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify
> > 
> > The new HEAD is 6e3019a9bf55000694b0d7058b39a1eebdf9877a.
> 
> Now the build fails on allyes32config:
> 
> drivers/acpi/numa.c:293: error: 'NR_NODE_MEMBLKS' undeclared (first use in this function)
> drivers/acpi/numa.c:293: error: (Each undeclared identifier is reported only once
> drivers/acpi/numa.c:293: error: for each function it appears in.)

Okay, updated again.  I'm trying to build all combinations of the
several affected configurations now.  I'll let you know how it turns
out.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify

The new HEAD is e23bba604433a202cd301a976454a90ea6b783ef.

Thanks.

-- 
tejun
