Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab2DLOOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:14:50 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:48786 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933556Ab2DLOOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:14:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120412131045.GB31384@kroah.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com> <20120412030044.GA26236@kroah.com>
 <4F867A95.9030104@ti.com> <20120412131045.GB31384@kroah.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 12 Apr 2012 19:44:27 +0530
Message-ID: <CAMQu2gx6WvekvYLByhLs0rH4QvN7dE0c_2S6wuQKthL9tT4Esw@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
To: Greg KH <greg@kroah.com>
Cc: Paul Walmsley <paul@pwsan.com>, Aneesh V <aneesh@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, mgreer@animalcreek.com, msalter@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 6:40 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Apr 12, 2012 at 12:17:49PM +0530, Santosh Shilimkar wrote:
>> I was hoping that we will have some thing like drivers/memory/*
>> but since it doesn't exist, we used drivers/misc.
>
> Why not create it?  I have no objection to that, it makes it more
> obvious as to what this really is.
>
Looks like I should have this question earlier.
EMIF driver is perfect candidate for drivers/memory/

Thanks Greg for suggestion. We will go ahead and
create drivers/memory and have EMIF drivers there.

Regards
Santosh
