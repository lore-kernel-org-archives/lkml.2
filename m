Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab0JTW3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:29:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1058 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab0JTW3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:29:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6142"; a="58699691"
Message-ID: <4CBF6D38.3080208@codeaurora.org>
Date: Wed, 20 Oct 2010 15:29:12 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Daniel Walker <dwalker@codeaurora.org>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, mattw@codeaurora.org,
        akpm@linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] Add OMAP hardware spinlock misc driver
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>	<1287531090.9245.139.camel@c-dwalke-linux.qualcomm.com>	<AANLkTikPnm1NK1wGGzbOuNoCOnAcSp=RC8mTW2yx3u0s@mail.gmail.com> <AANLkTimSL3UN6V45-+x7+wyT9Oz1Jfy+LesAUxMcPNqd@mail.gmail.com>
In-Reply-To: <AANLkTimSL3UN6V45-+x7+wyT9Oz1Jfy+LesAUxMcPNqd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  Indeed. Where is that MSM code ?

We don't have an equivalent feature on MSM, nor any plans for one.  Daniel was thinking of an internal test feature that had been deprecated a while ago.

- Bryan

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
