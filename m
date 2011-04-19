Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1DSJKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:10:35 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:45628 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921Ab1DSJKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:10:33 -0400
Message-ID: <4DAD516F.50901@st.com>
Date: Tue, 19 Apr 2011 14:40:07 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [PATCH V2 7/7] dmaengine/dw_dmac: implement pause and resume
 in dwc_control
References: <cover.1303194835.git.viresh.kumar@st.com> <a1168e413888e35badd9fab6b1626fcfe355dc9b.1303194836.git.viresh.kumar@st.com> <20110419085514.GG2820@pulham.picochip.com>
In-Reply-To: <20110419085514.GG2820@pulham.picochip.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 02:25 PM, Jamie Iles wrote:
>From the Synopsys datasheet it looks to me like pausing by clearing the 
> channel enable bit could cause data to be lost.  I think you need to set 
> the CH_SUSP bit and wait for the FIFO_EMPTY flag to go high then disable 
> the channel.

Yes, Previously i looked at some other doc of dwc and couldn't find this info.
But now found it in datasheet. Will correct and resend it.

-- 
viresh
