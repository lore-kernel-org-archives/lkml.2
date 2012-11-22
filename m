Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2KVUxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:53:21 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44116 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964875Ab2KVS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:36 -0500
MIME-Version: 1.0
In-Reply-To: <20121122102710.GD4328@gmail.com>
References: <f1d508c64a01dfd492a1ab1fda28af4b7647d8ab.1353560936.git.viresh.kumar@linaro.org>
	<20121122102710.GD4328@gmail.com>
Date: Thu, 22 Nov 2012 22:40:54 +0530
Message-ID: <CAKohpo=gctcd5+bZ8xeJn-Cx3=+=+uxaCzEoZhFmp+XaJSpf9Q@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] mfd: stmpe: Use devm_*() routines
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2012 15:57, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 22 Nov 2012, Viresh Kumar wrote:
>
>> This patch frees stmpe driver from tension of freeing resources :)
>> devm_* derivatives of multiple routines are used while allocating resources,
>> which would be freed automatically by kernel.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

> Acked-by: Lee Jones <lee.jones@linaro.org>

Hi Sameo,

Please apply this patch only from this series. I will not resend it in
V3 of my set.

--
viresh
