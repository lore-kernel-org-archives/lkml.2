Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab1G2PZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:25:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63385 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1G2PZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <1311941138.1536.528.camel@vkoul-udesk3>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<1e5012faf0649e7ed0113960a9ac8302e46f1354.1311936524.git.viresh.kumar@st.com>
	<1311941138.1536.528.camel@vkoul-udesk3>
Date: Fri, 29 Jul 2011 08:25:09 -0700
Message-ID: <CAOh2x=nn7Hy0_gHU2UDhwpj4MocN4rTYEK+VcwXpw9gon56b6Q@mail.gmail.com>
Subject: Re: [PATCH 02/18] dmaengine/amba-pl08x: Resolve formatting issues
From: viresh kumar <viresh.linux@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Viresh Kumar <viresh.kumar@st.com>, linus.walleij@linaro.org,
        dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/11, Koul, Vinod <vinod.koul@intel.com> wrote:
> On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
>>  				/*
>>  				 * So now we know how many bytes to transfer
>> -				 * to get to the nearest boundary.  The next
>> -				 * LLI will past the boundary.  However, we
>> +				 * to get to the nearest boundary. The next
>> +				 * LLI will past the boundary. However, we
>>  				 * may be working to a boundary on the slave
>> -				 * bus.  We need to ensure the master stays
>> +				 * bus. We need to ensure the master stays
>>  				 * aligned, and that we are working in
>>  				 * multiples of the bus widths.
>>  				 */
> This looks v ugly, care to fix this.
> 80chars should be followed with a little common sense, if it sacrifices
> code readability then pls ignore it.
> In places where you can fix it w/o sacrificing code quality pls do it :)

Ok.

>>  				/* FIXME: use round_down()? */
> while you are fixing the driver, care to fix the FIXME as well?

Already removed this. :)

--
viresh
