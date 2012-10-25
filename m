Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945968Ab2JYNTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:19:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46499 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422653Ab2JYNTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:19:04 -0400
Message-ID: <50893C45.7010109@gmail.com>
Date: Thu, 25 Oct 2012 08:19:01 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: grant.likely@secretlab.ca, spear-devel@list.st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@intel.com
Subject: Re: [PATCH] dt: add helper function to read u8 & u16 variables &
 arrays
References: <425b4bec021bce9a2de49959121907aeede6a0b9.1350064805.git.viresh.kumar@linaro.org> <CAKohpom42SCMJ+=TdvAjqT0ibRugJi_gXkLy+49N6ExcRZqxLQ@mail.gmail.com>
In-Reply-To: <CAKohpom42SCMJ+=TdvAjqT0ibRugJi_gXkLy+49N6ExcRZqxLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 02:03 AM, Viresh Kumar wrote:
> On 12 October 2012 23:31, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> This adds following helper routines:
>> - of_property_read_u8_array()
>> - of_property_read_u16_array()
>> - of_property_read_u8()
>> - of_property_read_u16()
>>
>> First two actually share most of the code with of_property_read_u32_array(), so
>> the common part is taken out into a macro, which can be used by all three
>> *_array() routines.
> 
> Hi Rob,
> 
> Any comment here?

For some reason, this does not show up on the list either in my mail or
mail list archives, but it is in patchwork. Can you resend it please.

The main question I have is be32_to_cpup() the right thing to do. I
would expect byte arrays to not need endian conversion, but I haven't
looked at how '/bits/ x' data is stored.

Rob
