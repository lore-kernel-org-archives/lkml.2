Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1IUFpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:45:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1IUFpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:45:50 -0400
Message-ID: <4E7979E2.4020901@redhat.com>
Date: Wed, 21 Sep 2011 08:45:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        jeremy@goop.org
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple events
 and unknown NMIs
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com> <1316529792-6560-5-git-send-email-dzickus@redhat.com> <4E78CBF7.4060004@redhat.com> <20110920201051.GL5795@redhat.com>
In-Reply-To: <20110920201051.GL5795@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 11:10 PM, Don Zickus wrote:
> On Tue, Sep 20, 2011 at 08:23:03PM +0300, Avi Kivity wrote:
> >  >V4:
> >  >    - clean up fixes, like adding 'static', rename save_rip to last_nmi_rip
> >  >
> >  >
> >
> >  Missing a zeroing of last_nmi_rip in the idle path.  Otherwise, as
> >  Andi points out, and idle machine will always see NMIs coming in
> >  from the hlt/mwait address and detect them as back-to-back NMIs.
>
> You mean something like this?
>

Yes.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

