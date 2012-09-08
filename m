Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab2IHAoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:44:03 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58780 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757577Ab2IHAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B7041B73E9@DFLE12.ent.ti.com>
References: <1346350624-27291-1-git-send-email-m-karicheri2@ti.com>
	<20120907212853.20289.86031@nucleus>
	<3E54258959B69E4282D79E01AB1F32B7041B73E9@DFLE12.ent.ti.com>
Date: Fri, 7 Sep 2012 17:43:55 -0700
Message-ID: <CAN8TOE8tpyPK2V4=YQWP7bK7e5AqFDE27EBpKhn0hj-u6r3HAA@mail.gmail.com>
Subject: Re: [PATCH] mtd:nand:clk: preparation for switch to common clock framework
From: Brian Norris <computersforpeace@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 7, 2012 at 2:56 PM, Karicheri, Muralidharan
<m-karicheri2@ti.com> wrote:
> How do these patch get to upstream? Does this get merged through davinci maintainer or through individual subsystem maintainers?

I think this driver would be taken by David Woodhouse in his linux-mtd
repo. Usually Artem Bityutskiy gleans the mailing list of patches and
puts them in his l2-mtd-2.6 git repo to help David out. Give it some
time, and I'm sure they'll be taking it. We don't really have a
full-time maintainer!

Brian
