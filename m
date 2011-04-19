Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab1DSGgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:36:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:65315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab1DSGgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:36:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,237,1301900400"; 
   d="scan'208";a="735392156"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: viresh kumar <viresh.kumar@st.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Date: Tue, 19 Apr 2011 12:03:33 +0530
Subject: RE: [PATCH 2/6] dmaengine/dw_dmac: Enable resubmission from
 callback routine.
Thread-Topic: [PATCH 2/6] dmaengine/dw_dmac: Enable resubmission from
 callback routine.
Thread-Index: Acv+WmOd37VBVcO7Rn+/lFkFwhwHDwAAC6mQ
Message-ID: <438BB0150E931F4B9CE701519A44630108519E1C1D@bgsmsx502.gar.corp.intel.com>
References: <e52c8e679fbf3007cf7e5e4bcfc86ea208a09d7c.1303123511.git.viresh.kumar@st.com>
 <cf350c267897bd4eaf5a027c659771eee117ac74.1303123511.git.viresh.kumar@st.com>
 <438BB0150E931F4B9CE701519A44630108519E1BE6@bgsmsx502.gar.corp.intel.com>
 <4DAD2A61.4020406@st.com>
In-Reply-To: <4DAD2A61.4020406@st.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 11:53 AM, viresh kumar wrote:
> On 04/19/2011 11:42 AM, Koul, Vinod wrote:
> > On 04/18/2011 04:20 PM, viresh kumar wrote:
> Vinod,
> 
> I initiated this discussion few days back on a separate thread:
> 
> http://www.spinics.net/lists/arm-kernel/msg121139.html
> 
> And so implemented this.
Ahhh, on the road, catching up on email...

This was a dma engine requirement, not absolute for slave-dma.
But would be good idea to resist this. What is your reason for this?

I am adding documentation for slave, hopefully will complete after my
vacation, should help to clarify these things

~Vinod

