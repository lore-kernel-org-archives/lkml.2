Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2KTH4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 02:56:32 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64467 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2KTH4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 02:56:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpomky4s0OBYtQhDTZc9OeSo6w_mN9uAqUXpukqR1icvKPA@mail.gmail.com>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
	<27d9eea3815593df228c85958096bc14d7985e7e.1352381962.git.viresh.kumar@linaro.org>
	<CAKohpomky4s0OBYtQhDTZc9OeSo6w_mN9uAqUXpukqR1icvKPA@mail.gmail.com>
Date: Tue, 20 Nov 2012 13:26:29 +0530
Message-ID: <CAKohpoknJqMzro4gbTH+Rh=T2Bc9ZOVmDbYZsqC4Fjq2Sqsszg@mail.gmail.com>
Subject: Re: [PATCH 2/3] Input: spear-keyboard: Add clk_{un}prepare() support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2012 11:27, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 8 November 2012 19:10, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
>>
>> clk_{un}prepare is mandatory for platforms using common clock framework. Because
>> for SPEAr we don't do anything in clk_{un}prepare() calls, just call them ones
>> in probe/remove.
>>
>> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Missed applying this one ?

This one you missed :)
