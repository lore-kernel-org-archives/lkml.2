Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0DENrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 09:47:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36358 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751107Ab0DENq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 09:46:59 -0400
Date: Mon, 5 Apr 2010 14:46:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk
Subject: Re: [PATCH 1/4]-V2 Move TPS6507x register definition to header
 file.
Message-ID: <20100405134657.GF6580@rakim.wolfsonmicro.main>
References: <1270244253-4234-1-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-2-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270244253-4234-2-git-send-email-todd.fischer@ridgerun.com>
X-Cookie: Pyros of the world... IGNITE !!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 03:37:30PM -0600, Todd Fischer wrote:
> Other sub-drivers for the TPS6507x chip will need to use register 
> definition so move it out of the source file and into a header file.
> 
> Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
