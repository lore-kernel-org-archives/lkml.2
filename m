Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab1G2LYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:24:37 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:48347 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932077Ab1G2LYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:24:36 -0400
X-Greylist: delayed 2061 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jul 2011 07:24:35 EDT
Message-ID: <4E329848.7070606@st.com>
Date: Fri, 29 Jul 2011 16:53:52 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
References: <cover.1311936523.git.viresh.kumar@st.com> <20110729105759.GE25640@n2100.arm.linux.org.uk> <4E329616.2030505@st.com> <20110729111920.GK25640@n2100.arm.linux.org.uk>
In-Reply-To: <20110729111920.GK25640@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 04:49 PM, Russell King - ARM Linux wrote:
> Ok, so lets have the driver explicitly enforce one SG entry if peripheral
> flow is set.  It would also be a good idea to pass not zero length, but
> the real transfer size in the SG entry for the sake of having the API
> know the full information about the transfer.

In my case, JPEG driver doesn't know how much data to transfer. So i have to
send zero from there. Also, i am not sure why would peripheral needs to be
flow controller if the peripherals driver already know how much to transfer?

> 
> (Ok, it already only supports one SG entry, but that's something else
> which needs fixing - which may be possible now that you've cleaned up
> the LLI creation code.)
> .

Yes. I cleaned it up.

-- 
viresh
