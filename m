Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759179Ab2C2L3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:29:17 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:32957 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab2C2L3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:29:11 -0400
Message-ID: <1333020132.27838.5.camel@ayu>
Subject: Re: 3.3 panic on boot caused by
 4949be16822e92a18ea0cc1616319926628092ee
From: Calvin Walton <calvin.walton@kepstin.ca>
To: George Spelvin <linux@horizon.com>
Cc: jbarnes@virtuousgeek.org, mjg@redhat.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Thu, 29 Mar 2012 07:22:12 -0400
In-Reply-To: <20120329101216.17321.qmail@science.horizon.com>
References: <20120329101216.17321.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.0
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 06:12 -0400, George Spelvin wrote:
> Hopefully there's enough information here to track down the regression.
> The processor is a i7-2700k, with 16G of memory.
> 
> Sorry for the delay; I noticed this last week, but didn't get around to
> transcribing the oops until just now.
> 
> [502]$ git bisect bad
> 4949be16822e92a18ea0cc1616319926628092ee is the first bad commit
> commit 4949be16822e92a18ea0cc1616319926628092ee
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Tue Mar 6 13:41:49 2012 -0500
> 
>     PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled

With any luck, your issue should be fixed by this patch:
http://article.gmane.org/gmane.linux.kernel.pci/14503

Hopefully it will be included in an upcoming stable release :)

-- 
Calvin Walton <calvin.walton@kepstin.ca>

