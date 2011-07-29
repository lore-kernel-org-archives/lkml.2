Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab1G2MoG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 08:44:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42866 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab1G2MoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 08:44:05 -0400
Date: Fri, 29 Jul 2011 13:43:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: viresh kumar <viresh.kumar@st.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vipin KUMAR <vipin.kumar@st.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 00/18] dmaengine/amba-pl08x updates
Message-ID: <20110729124346.GL25640@n2100.arm.linux.org.uk>
References: <cover.1311936523.git.viresh.kumar@st.com> <20110729105759.GE25640@n2100.arm.linux.org.uk> <4E329616.2030505@st.com> <20110729111920.GK25640@n2100.arm.linux.org.uk> <4E329848.7070606@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E329848.7070606@st.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:53:52PM +0530, viresh kumar wrote:
> On 07/29/2011 04:49 PM, Russell King - ARM Linux wrote:
> > Ok, so lets have the driver explicitly enforce one SG entry if peripheral
> > flow is set.  It would also be a good idea to pass not zero length, but
> > the real transfer size in the SG entry for the sake of having the API
> > know the full information about the transfer.
> 
> In my case, JPEG driver doesn't know how much data to transfer. So i have to
> send zero from there. Also, i am not sure why would peripheral needs to be
> flow controller if the peripherals driver already know how much to transfer?

If the jpeg driver doesn't know how much data will be transferred, how
can it allocate a buffer for the device to DMA into?
