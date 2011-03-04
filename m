Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab1CDJ5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:57:05 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:54460 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab1CDJ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:57:04 -0500
Message-ID: <4D70B73A.5070105@st.com>
Date: Fri, 4 Mar 2011 15:26:10 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, amitgoel <amit.goel@st.com>,
        "hans-christian.egtvedt@atmel.com" <hans-christian.egtvedt@atmel.com>
Subject: Re: [PATCH V2 06/13] dw_dmac: Change value of DWC_MAX_COUNT to 4095.
References: <cover.1299146382.git.viresh.kumar@st.com> <0e767d5a3f538e476b72c7d5ccac88e2f5fcdf1a.1299146382.git.viresh.kumar@st.com>
In-Reply-To: <0e767d5a3f538e476b72c7d5ccac88e2f5fcdf1a.1299146382.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 03:47 PM, Viresh KUMAR wrote:
> - * words, we can do 8192 bytes per descriptor.
> + * words, we can do 16480 bytes per descriptor.
>   *

Sorry this should be 16380. Will resend this patch.

-- 
viresh
