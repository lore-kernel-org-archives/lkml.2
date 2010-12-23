Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab0LWWk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 17:40:59 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:38862 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab0LWWk6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:40:58 -0500
MIME-Version: 1.0
In-Reply-To: <20101215085305.GC1639@bicker>
References: <1292358798-25875-1-git-send-email-rene.sapiens@ti.com>
	<1292358798-25875-2-git-send-email-rene.sapiens@ti.com>
	<1292358798-25875-3-git-send-email-rene.sapiens@ti.com>
	<1292358798-25875-4-git-send-email-rene.sapiens@ti.com>
	<1292358798-25875-5-git-send-email-rene.sapiens@ti.com>
	<1292358798-25875-6-git-send-email-rene.sapiens@ti.com>
	<20101215085305.GC1639@bicker>
Date: Thu, 23 Dec 2010 16:40:57 -0600
Message-ID: <AANLkTinsSAfNxNkcv6QK0VKbs2JXVtRLO0Yxqyx5-NPd@mail.gmail.com>
Subject: Re: [PATCH 05/12] staging:tidspbridge - set5 remove hungarian from structs
From: "Sapiens, Rene" <rene.sapiens@ti.com>
To: Dan Carpenter <error27@gmail.com>, Rene Sapiens <rene.sapiens@ti.com>,
        omar.ramirez@ti.com, nm@ti.com, ohad@wizery.com, ionut.nicu@mindbit.ro,
        devel@driverdev.osuosl.org, ivan.gomez@ti.com, x0095078@ti.com,
        felipe.contreras@gmail.com, ernesto@ti.com,
        linux-kernel@vger.kernel.org, x0095840@ti.com,
        linux-omap@vger.kernel.org, ameya.palande@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Wed, Dec 15, 2010 at 2:53 AM, Dan Carpenter <error27@gmail.com> wrote:
> On Tue, Dec 14, 2010 at 02:33:11PM -0600, Rene Sapiens wrote:
>> -                                 pfn_unload(pnode->nldr_node_obj,
>> +                                 load(pnode->nldr_node_obj,
>>                                              NLDR_EXECUTE);
>
> Unload got swapped with load here.
>
> This might have been easier to with Coccinelle instead of by hand...
>

I'm sorry for the delay, i did use some scripts to identify/replace
the words, this last one should be because of my lasts coding style
fixes after changes, i will fix it and send the patch again. Indeed
Coccinelle is a very good option too.

-- 
Regards,
Rene Sapiens
