Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2J2KgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:36:22 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:62557 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab2J2KgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:36:21 -0400
Message-ID: <1351506978.1339.8.camel@x61.thuisdomein>
Subject: Re: [PATCH] aic7xxx_old: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 11:36:18 +0100
In-Reply-To: <1348219723.1581.5.camel@x61.thuisdomein>
References: <1348219723.1581.5.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2012 10:36:19.0407 (UTC) FILETIME=[3B6F2DF0:01CDB5C1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 11:28 +0200, Paul Bolle wrote:
> Building the aic7xxx_old driver triggers these GCC warnings:
>     drivers/scsi/aic7xxx_old.c:7901:5: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]
>     drivers/scsi/aic7xxx_old.c:7898:5: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]
>     drivers/scsi/aic7xxx_old.c:8517:5: warning: case value '257' not in enumerated type 'ahc_chip' [-Wswitch]
>     drivers/scsi/aic7xxx_old.c:8510:5: warning: case value '513' not in enumerated type 'ahc_chip' [-Wswitch]
> 
> Fix these warnings by adopting the idiom used elsewhere in this driver.
> Since AHC_EISA and AHC_VL are only ever set for AHC_AIC7770 this fix
> should not lead to any functional change.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) I noticed these warnings while building v3.6-rc6 on current Fedora
> 17, using Fedora's default config.

Identical warnings can be seen while building v3.7-rc3. What's the
status of my patch? Did anyone found some time to have a look at it?


Paul Bolle

