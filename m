Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1G2PrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:47:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58046 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1G2PrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <1311941355.1536.529.camel@vkoul-udesk3>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<e2c1bd6941e88f8988b1942c13c20cf436b3a963.1311936524.git.viresh.kumar@st.com>
	<1311941355.1536.529.camel@vkoul-udesk3>
Date: Fri, 29 Jul 2011 08:47:06 -0700
Message-ID: <CAOh2x=kqa0GxRH9o=8faPhuyyLcqxH8+AOowBTK_gMaDgJyeVA@mail.gmail.com>
Subject: Re: [PATCH 04/18] dmaengine/amba-pl08x: Remove redundant comment and
 rewrite original
From: viresh kumar <viresh.linux@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>, linus.walleij@linaro.org,
        linux@arm.linux.org.uk
Cc: Viresh Kumar <viresh.kumar@st.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        armando.visconti@st.com, shiraz.hashim@st.com, vipin.kumar@st.com,
        rajeev-dlh.kumar@st.com, deepak.sikri@st.com, vipulkumar.samar@st.com,
        amit.virdi@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/11, Koul, Vinod <vinod.koul@intel.com> wrote:
> On Fri, 2011-07-29 at 16:19 +0530, Viresh Kumar wrote:
>>  /*
>> - * Autoselect a master bus to use for the transfer this prefers the
>> - * destination bus if both available if fixed address on one bus the
>> - * other will be chosen
>> + * Autoselect a master bus to use for the transfer
>> + * - prefers the destination bus if both available
>> + * - if fixed address on one bus the other will be chosen
> Not sure I get it, English is not my first language :)

Nor mine either. :)

Will give some more explanation.

But before that i wanted to know the exact purpose of this
master-slave concept here.
Probably it is for choosing the victim for reduction of width, in case
src and dest addresses
are misaligned to each other.
@Russell and Linus: Is this correct?

--
viresh
