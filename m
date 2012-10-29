Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2J2MpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 08:45:20 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:1199 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab2J2MpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 08:45:18 -0400
Message-ID: <1351514716.1339.15.camel@x61.thuisdomein>
Subject: Re: [PATCH] aic7xxx_old: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 13:45:16 +0100
In-Reply-To: <1351513026.2480.4.camel@dabdike.sthat4.btopenzone.com>
References: <1348219723.1581.5.camel@x61.thuisdomein>
	 <1351506978.1339.8.camel@x61.thuisdomein>
	 <1351513026.2480.4.camel@dabdike.sthat4.btopenzone.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2012 12:45:16.0655 (UTC) FILETIME=[3F3187F0:01CDB5D3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 12:17 +0000, James Bottomley wrote:
> the aic7xxx_old driver is in deep maintenance; I don't think anyone can
> actually test changes to it anymore, so we just keep it around unchanged
> for the odd really old card that can't be driven by the current driver.
> For this reason, we tend only to do tested bug fixes to it because
> no-one will notice if any error is introduced.
> 
> mvsas has a maintainer: poke them harder

According to MAINTAINERS that's you. Is Xiangliang Yu perhaps the actual
maintainer?

> and aic94xx is currently
> maintainerless, so it will depend on someone finding the time to test.

Thanks,


Paul Bolle

