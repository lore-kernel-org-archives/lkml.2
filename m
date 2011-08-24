Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1HXVBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:01:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:35294 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1HXVBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:01:32 -0400
MIME-Version: 1.0
Message-ID: <1b9107c1-20a3-4e2c-9d83-6449857fb514@default>
Date: Wed, 24 Aug 2011 14:01:01 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, Chris Mason <chris.mason@oracle.com>,
        sjenning@linux.vnet.ibm.com, jackdachef@gmail.com, cyclonusj@gmail.com
Subject: RE: [PATCH V7 0/4] mm: frontswap: overview (and proposal to merge at
 next window)
References: <20110823145735.GA23160@ca-server1.us.oracle.com
 20110824205355.GD27865@dumpdata.com>
In-Reply-To: <20110824205355.GD27865@dumpdata.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090204.4E55669C.0060,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk
> Subject: Re: [PATCH V7 0/4] mm: frontswap: overview (and proposal to merge at next window)
> 
> On Tue, Aug 23, 2011 at 07:57:35AM -0700, Dan Magenheimer wrote:
> > [PATCH V7 0/4] mm: frontswap: overview (and proposal to merge at next window)
> 
> Is there a git branch of these patches?

I'll get V7 into linux-next in a day or two (assuming someone else
doesn't find a glaring problem before then which would require a V8).
Linux-next currently has V6.
 
> Also, on a unrelated note - your patches have 'Subject: Subject: [PATCH..'
> - you might want to fix your fancy mail sending tools.

Sigh, sorry.  It's an artifact of my use of "git am".  I thought I
had fixed it in my scripts after a trial send to myself, but neglected
to move the changed script to my external-email-sending machine.

Dan
