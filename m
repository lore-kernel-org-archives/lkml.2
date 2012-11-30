Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2K3CUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:20:18 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63723 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab2K3CUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:20:13 -0500
MIME-Version: 1.0
In-Reply-To: <20121130021335.GD2056@kroah.com>
References: <1354180728-1958-1-git-send-email-ngupta@vflare.org>
	<20121130003609.GA18630@blaptop>
	<20121130021335.GD2056@kroah.com>
Date: Thu, 29 Nov 2012 18:20:12 -0800
Message-ID: <CAPkvG_d3mY84wQzcVusCnqdO0Zy5wMbr6Wqs+TyAzMBut_AVUw@mail.gmail.com>
Subject: Re: [PATCH v3] zram: fix invalid memory references during disk write
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 6:13 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Nov 30, 2012 at 09:36:09AM +0900, Minchan Kim wrote:
>> Hi Greg,
>>
>> I would like to tidy zram_bvec_write up but it needs more churn
>> than needed to fix this bug and makes review hard. So I want you to pick up
>> this patch asap because it's a candidate of stable.
>
> Ok, I have way too many different, and competing, zram patches in my
> inbox right now.
>
> So I'm just going to delete them all, and ask Nitin to resend them all
> so I know what is going on here.
>
> Nitin, is that ok?
>

Sure. I will also include affected stable version in the changelog (or
whatever stable_kernel_rules says).

Thanks,
Nitin
