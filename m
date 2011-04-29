Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1D2D0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 23:26:20 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:33821 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740Ab1D2D0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 23:26:19 -0400
Message-ID: <4DBA2F97.7080801@st.com>
Date: Fri, 29 Apr 2011 08:55:11 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V3 3/7] dmaengine/dw_dmac: don't call callback routine
 in case dmaengine_terminate_all() is called
References: <cover.1303896566.git.viresh.kumar@st.com> <b5e9038ecac3f44d265c7321de551bd9b66cdddd.1303896567.git.viresh.kumar@st.com> <20110428171118.GC17290@n2100.arm.linux.org.uk>
In-Reply-To: <20110428171118.GC17290@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2011 10:41 PM, Russell King - ARM Linux wrote:
>> >  static void
>> > -dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc)
>> > +dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
>> > +		bool callback_required)
> If you're using 'bool' then using 'true' and 'false' with it rather than
> '1' and '0' is a good idea.

Yes, will correct this.

-- 
viresh
