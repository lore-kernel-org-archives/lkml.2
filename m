Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1G2Lat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:30:49 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:46052 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106Ab1G2Las (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:30:48 -0400
Message-ID: <4E3299BF.6030707@st.com>
Date: Fri, 29 Jul 2011 17:00:07 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Armando VISCONTI <armando.visconti@st.com>,
        Shiraz HASHIM <shiraz.hashim@st.com>, Vipin KUMAR <vipin.kumar@st.com>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Deepak SIKRI <deepak.sikri@st.com>,
        Vipul Kumar SAMAR <vipulkumar.samar@st.com>,
        Amit VIRDI <Amit.VIRDI@st.com>, Pratyush ANAND <pratyush.anand@st.com>,
        Bhupesh SHARMA <bhupesh.sharma@st.com>,
        "viresh.linux@gmail.com" <viresh.linux@gmail.com>
Subject: Re: [PATCH 12/18] dmaengine/amba-pl08x: Add	prep_single_byte_llis()
 routine
References: <cover.1311936523.git.viresh.kumar@st.com> <cacf3470c622f311c894e6c72f13ba02be82af73.1311936524.git.viresh.kumar@st.com> <20110729110638.GH25640@n2100.arm.linux.org.uk>
In-Reply-To: <20110729110638.GH25640@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 04:36 PM, Russell King - ARM Linux wrote:
>> > +static inline void prep_byte_width_lli(struct pl08x_lli_build_data *bd,
>> > +		u32 *cctl, u32 len, int num_llis, size_t *total_bytes)
>> > +{
>> > +		*cctl = pl08x_cctl_bits(*cctl, 1, 1, len);
>> > +		pl08x_fill_lli_for_desc(bd, num_llis, len, *cctl);
>> > +		(*total_bytes) += len;
> Seeing as your patch series started with a cleanup of spacing/tabbing,
> it's surprising to find a patch introducing new code which has broken
> tabbing.
> 

Haah.... How can i do this? Sorry will fix this.

-- 
viresh
