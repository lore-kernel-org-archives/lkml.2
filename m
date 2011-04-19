Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab1DSGXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:23:55 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:56460 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251Ab1DSGXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:23:53 -0400
Message-ID: <4DAD2A61.4020406@st.com>
Date: Tue, 19 Apr 2011 11:53:29 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/6] dmaengine/dw_dmac: Enable resubmission from callback
 routine.
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com> <cf350c267897bd4eaf5a027c659771eee117ac74.1303123511.git.viresh.kumar@st.com> <438BB0150E931F4B9CE701519A44630108519E1BE6@bgsmsx502.gar.corp.intel.com>
In-Reply-To: <438BB0150E931F4B9CE701519A44630108519E1BE6@bgsmsx502.gar.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 11:42 AM, Koul, Vinod wrote:
> On 04/18/2011 04:20 PM, viresh kumar wrote:
>>
>> Resubmission of new transfer must be allowed from callbacks. For this release
>> lock before calling callback routine and enable them again.
> Why would you like to do that?
> 
> IMO it's not a good thing as you are essentially doing it in your tasklet...
> Make sure the submit() is done by client before this and you use it to start
> next transaction in you tasklet and let client know in callback txn is
> finished.
> 

Vinod,

I initiated this discussion few days back on a separate thread:

http://www.spinics.net/lists/arm-kernel/msg121139.html

And so implemented this.

-- 
viresh
