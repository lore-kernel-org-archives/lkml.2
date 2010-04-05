Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0DENsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 09:48:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36366 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751107Ab0DENsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 09:48:32 -0400
Date: Mon, 5 Apr 2010 14:48:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk
Subject: Re: [PATCH 2/4]-V2 Make room for other tps6507x drivers to have
 board specific initialization data.
Message-ID: <20100405134831.GG6580@rakim.wolfsonmicro.main>
References: <1270244253-4234-1-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-2-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-3-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270244253-4234-3-git-send-email-todd.fischer@ridgerun.com>
X-Cookie: Pyros of the world... IGNITE !!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 03:37:31PM -0600, Todd Fischer wrote:
> Add mfd structure which refrences sub-driver initialization data. For example,
> for a giving hardware implementation, the voltage regulator sub-driver
> initialization data provides the mapping betten a voltage regulator and what
> the output voltage is being used for.
> 
> Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
