Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1D0Dri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 23:47:38 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:50855 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887Ab1D0Drh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 23:47:37 -0400
Message-ID: <4DB791BB.8050207@st.com>
Date: Wed, 27 Apr 2011 09:17:07 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>
Subject: Re: [PATCH 1/6] dmaengine/dw_dmac: Replace spin_lock_bh with	irqsave
 variants
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com> <4DAD2AE9.7060106@st.com> <20110426203306.GC17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110426203306.GC17290@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 02:03 AM, Russell King - ARM Linux wrote:
> On Tue, Apr 19, 2011 at 11:55:45AM +0530, viresh kumar wrote:
>> This must have been added in dw_dma_chan instead :(
>> Will resend it.
> 
> Even that doesn't work.  It has to be a local variable.

I assumed that flags wouldn't be updated if lock is already taken by some other thread.
In which case global flags would have worked fine.
But as i see now, that's incorrect. Flags is always changed, whether or not lock is taken.

Will resend it again.

-- 
viresh
