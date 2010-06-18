Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab0FRN4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:56:17 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:32853 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932422Ab0FRN4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:56:16 -0400
Message-ID: <4C1B7AF2.1060500@st.com>
Date: Fri, 18 Jun 2010 19:26:02 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "'Shiraz HASHIM'" <shiraz.hashim@st.com>,
       Armando VISCONTI <armando.visconti@st.com>
Subject: Re: Query dw_dmac driver: All descriptors done, but channel not idle!
References: <4C1B75B7.1080104@st.com> <20100618155234.1fc40ce7@hskinnemoen-d830>
In-Reply-To: <20100618155234.1fc40ce7@hskinnemoen-d830>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/2010 7:22 PM, Haavard Skinnemoen wrote:
> Viresh KUMAR <viresh.kumar@st.com> wrote:
>> Can somebody please confirm, if it a known issue or not? Or if there
>> are some solutions for this problem.
> 
> I'm not aware of any such issue. The code was added as a purely
> defensive thing; when writing it, I just thought about what might
> happen if we go through all our descriptors without finding the current
> one, and added some code to report the issue and try to recover.
> 
> I suppose it might be caused by some issue with the peripheral itself,
> but I think it's more likely to be caused by some race condition in the
> driver, i.e. something goes wrong when inserting or removing
> descriptors in the chain.
> 
> What might be very good to know at this point is the value of
> the llp variable, and perhaps also the value of the CH_EN register to
> see if the channel is idle or not.
> 

Thanks Haavard,

Will debug it further.

viresh.
