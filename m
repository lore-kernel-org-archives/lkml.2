Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0LATCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:02:01 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65034 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0LATCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D0BWzJjGEn0dv0ZlMZ1QLvR5z6LZDs/T0XWOS2r4jlszxSupESfJu1a7aM00wl3sK5
         Ct99CT4ntFwe80Yg43KQO53nnBaKmimpT9nDSPIFD0169oU/1q/icYjs3uYqSMcldztz
         7qIZCx9OHMXO4He8NPY2utloUjwZZxjsD7JoQ=
Date: Wed, 1 Dec 2010 22:01:55 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] x86, NMI: Remove DIE_NMI_IPI and add priorties to
	handlers
Message-ID: <20101201190155.GC6478@lenovo>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com> <1291156050-4482-5-git-send-email-dzickus@redhat.com> <20101201184128.GB6478@lenovo> <1291229622.32004.1886.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291229622.32004.1886.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 07:53:42PM +0100, Peter Zijlstra wrote:
...
> > 
> >  Don, maybe switching to say new chains like chain_perf and friends would be
> > more readable/clean? I'm not against this patch by any means, but just a thought ;)
> 
> Its a single event (NMI) so we only need a single notifier list, the
> current one seems to be just fine.
> 

 OK, i'm fine with either, just a thought

  Cyrill
