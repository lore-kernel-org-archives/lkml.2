Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1K0OXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 09:23:37 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:42420 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755375Ab1K0OXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 09:23:36 -0500
Message-ID: <4ED247C8.40002@st.com>
Date: Sun, 27 Nov 2011 19:53:04 +0530
From: Pratyush Anand <pratyush.anand@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Pavan Savoy <pavan_savoy@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] MISC: convert drivers/misc/* to use module_platform_driver()
References: <1322195099.30842.4.camel@phoenix>
In-Reply-To: <1322195099.30842.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 9:54 AM, Axel Lin wrote:
> This patch converts the drivers in drivers/misc/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>
> Cc: Ira W. Snyder<iws@ovro.caltech.edu>
> Cc: Pratyush Anand<pratyush.anand@st.com>
> Cc: Pavan Savoy<pavan_savoy@ti.com>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>

Acked-by: Pratyush Anand <pratyush.anand@st.com>
