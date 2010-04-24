Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0DWQ1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:27:48 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:60535 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0DWQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PZgh/drRvDjMk+R7X+ehALhn0ACBA1WtWjSe7tQujNTsyY42DsoY+uc7a+Zz3A5nbU
         rHcOxYbVaNjI5bquBknZ2NmR4bFlPVMxc9vco4t5Motf38sAPkMN2udcjGQlFhyofCHO
         pW4Eomi9023LK/cVMMLf/0ahJNUCJNAPv1XGU=
Date: Sat, 24 Apr 2010 19:28:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] procfs: fix tid fdinfo
Message-ID: <20100424162857.GB4428@x200>
References: <4BD1BF57.7070201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD1BF57.7070201@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 05:40:07PM +0200, Jerome Marchand wrote:
> -	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
> +	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),

Ick.

this is for stable@ as well

Cc: stable@kernel.org
