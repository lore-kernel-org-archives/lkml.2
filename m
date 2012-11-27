Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab2K0Cka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:40:30 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39849 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2K0Ck3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <20121126184015.784993E091F@localhost>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
	<7a48ae364663ab3a336251fada9aee07ccd728b8.1353610437.git.viresh.kumar@linaro.org>
	<20121123094132.EFCB73E07BE@localhost>
	<CAKohpomAM2pw9kgB6khtHzQ2WCXKZ9_pi1_sOH2dQToVS8ep4w@mail.gmail.com>
	<20121126184015.784993E091F@localhost>
Date: Tue, 27 Nov 2012 08:10:28 +0530
Message-ID: <CAKohpo=dHz-fJRdwovOWesAZJwibgrNk-+2t--JK+T_sBsu9Tw@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] mfd: stmpe: Update DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: lee.jones@linaro.org, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2012 00:10, Grant Likely <grant.likely@secretlab.ca> wrote:
> Ah, so it is configuring the way the device emits interrupts; not how
> the interrupt controller processes them. Fair enough.

Finally i am able to convince somebody that stmpe is different :)

> It would actually be good to ask the interrupt controller driver what
> kind of interrupt signal it expects for a given interrupt line. That
> should also solve the problem and I think it would be more useful to
> other devices. Can you investigate whether or not
> irqd_get_trigger_type() returns the information you need?

That's a pretty cool function to use. :)

Will check it out :)

--
viresh
