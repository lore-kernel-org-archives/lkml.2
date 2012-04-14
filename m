Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2DNTBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:01:42 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:26342 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752253Ab2DNTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:01:41 -0400
Date: Sat, 14 Apr 2012 15:01:36 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, arend@broadcom.com, zajec5@gmail.com
Subject: Re: [PATCH] bcma: use fallback sprom if no on chip sprom is available
Message-ID: <20120414190136.GA22035@elliptictech.com>
References: <20120414024430.GA19782@elliptictech.com>
 <1334407134-22803-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334407134-22803-1-git-send-email-hauke@hauke-m.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-14 14:38 +0200, Hauke Mehrtens wrote:
> bcma should check for a fallback sprom every time it can not find a
> sprom on the card itself or a normal external sprom mapped into the
> memory of the chip. When otp sprom support was introduced it tried to
> read out the sprom from the wireless chip also if no otp sprom was
> available. This caused a Data bus error in bcma_sprom_get() when
> reading out the sprom for the SoC.
[...]
> Reported-by: Nick Bowler <nbowler@elliptictech.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---

This patch appears to correct the issue on my RT-N16.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

