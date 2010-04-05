Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0DENtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 09:49:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36373 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751107Ab0DENtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 09:49:15 -0400
Date: Mon, 5 Apr 2010 14:49:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk
Subject: Re: [PATCH 3/4]-V2 Cleaned up name space so each MFD sub-driver
 uses a different name space.
Message-ID: <20100405134913.GH6580@rakim.wolfsonmicro.main>
References: <1270244253-4234-1-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-2-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-3-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-4-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270244253-4234-4-git-send-email-todd.fischer@ridgerun.com>
X-Cookie: Pyros of the world... IGNITE !!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 03:37:32PM -0600, Todd Fischer wrote:
> Move from using tps or tsp6507x to tps6057x_pmic in a consistent manner.
> 
> Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonicro.com>
