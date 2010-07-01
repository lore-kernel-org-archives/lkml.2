Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab0GABMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 21:12:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19036 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab0GABMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 21:12:50 -0400
Date: Wed, 30 Jun 2010 18:12:17 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: Ulrich Drepper <drepper@gmail.com>, viro@zeniv.linux.org.uk,
       smfrench@gmail.com, jlayton@redhat.com, mcao@us.ibm.com,
       aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       samba-technical@lists.samba.org, sjayaraman@suse.de,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file
 stats available
Message-ID: <20100701011217.GA5147@mail.oracle.com>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
	Ulrich Drepper <drepper@gmail.com>, viro@zeniv.linux.org.uk,
	smfrench@gmail.com, jlayton@redhat.com, mcao@us.ibm.com,
	aneesh.kumar@linux.vnet.ibm.com, linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org, sjayaraman@suse.de,
	linux-ext4@vger.kernel.org
References: <20100629224844.GF4150@mail.oracle.com>
 <AANLkTimSU_pCXW5zR8__Q3-fzgxwEUX8rPqLeZtPD_hX@mail.gmail.com>
 <20100629200259.23196.81509.stgit@warthog.procyon.org.uk>
 <20100629200315.23196.68742.stgit@warthog.procyon.org.uk>
 <26026.1277851016@redhat.com>
 <32322.1277854192@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32322.1277854192@redhat.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C2BEB82.0123:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 12:29:52AM +0100, David Howells wrote:
> Joel Becker <Joel.Becker@oracle.com> wrote:
> 
> > 	The less variable length stuff the better, I think.  At least,
> > for the stuff stat(2) already returns, you should have a fixed-size
> > structure.  Even if I only pass the GIVE_ME_UIDS flag, I don't want to
> > have to deal with the variable size stuff until I've actually asked for
> > esoteric things.  I'll know that the non-UIDS fields are garbage by the
> > fact that I didn't ask for them.
> 
> I was thinking of the fixed length xstat struct plus appendable extensions to
> be defined later.

	I meant this.

Joel

-- 

Life's Little Instruction Book #267

	"Lie on your back and look at the stars."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
