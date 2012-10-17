Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab2JQOGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:06:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:40797 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab2JQOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:06:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121017131422.GE11394@arwen.pp.htv.fi>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1350469879-16018-5-git-send-email-andriy.shevchenko@linux.intel.com>
	<20121017131422.GE11394@arwen.pp.htv.fi>
Date: Wed, 17 Oct 2012 19:36:08 +0530
X-Google-Sender-Auth: U-ug5voTsPZmu6-IGD8joG6v0C0
Message-ID: <CAOh2x==So5MRa7B=pKV7sw90OLUB8UFF00GVz0bg8J2-yOiwWQ@mail.gmail.com>
Subject: Re: [PATCHv2 4/4] dw_dmac: don't call platform_get_drvdata twice
From: viresh kumar <viresh.kumar@linaro.org>
To: balbi@ti.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 6:44 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Oct 17, 2012 at 01:31:18PM +0300, Andy Shevchenko wrote:
>
> I would suggest adding a commit log, but if maintainer is fine without,
> I'm fine too :-p

Should be there. But i am bored of giving this review comment now :)

--
viresh
