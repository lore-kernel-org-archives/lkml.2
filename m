Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab1CIOQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 09:16:05 -0500
Received: from mout.perfora.net ([74.208.4.195]:50999 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab1CIOQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 09:16:03 -0500
Date: Wed, 9 Mar 2011 09:14:41 -0500
From: Stephen Wilson <wilsons@start.ca>
To: Michel Lespinasse <walken@google.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] make *_gate_vma accept mm_struct instead of
	task_struct
Message-ID: <20110309141441.GA8861@fibrous.localdomain>
References: <1299630721-4337-1-git-send-email-wilsons@start.ca> <AANLkTikTEi8uKeCfPLoenNx9g6fLyAqNqfVdR=4KzNB3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikTEi8uKeCfPLoenNx9g6fLyAqNqfVdR=4KzNB3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:Y6fdG7Bns8PoQvOkhl1MsR7lI8KThj3x6vXo8q3YwWe
 55xUxmzgID8Wq+HCKtiV2MGEC5miGeEiiT/WrD+lxxZEYyeSkF
 2a3adWiLV8SstXu2nZwfa7maq4Svo9JJcaUsS51l9YHJiun1SF
 qbvG3FctO0LC+N4us15Um/BXtPvspfNkvNshIXisHNYqYUzs2y
 d0gJXXqvlagUNZv4dsALo2gcLpjX4hIK0ELHAzfmVA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:09:09AM -0800, Michel Lespinasse wrote:
> On Tue, Mar 8, 2011 at 4:31 PM, Stephen Wilson <wilsons@start.ca> wrote:
> > Morally, the question of whether an address lies in a gate vma should be asked
> > with respect to an mm, not a particular task.
> >
> > Practically, dropping the dependency on task_struct will help make current and
> > future operations on mm's more flexible and convenient.  In particular, it
> > allows some code paths to avoid the need to hold task_lock.
> 
> Reviewed-by: Michel Lespinasse <walken@google.com>
> 
> May I suggest ia32_compat instead of just compat for the flag name ?

Yes, sounds good to me.  Will change in the next iteration.

Thanks for the review!


> -- 
> Michel "Walken" Lespinasse
> A program is never fully debugged until the last user dies.


-- 
steve

