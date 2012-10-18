Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab2JRPQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:16:42 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50892 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2JRPQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:16:40 -0400
Date: Thu, 18 Oct 2012 11:18:00 -0400
From: Matt Porter <mporter@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Alsa Devel List <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH v2 2/2] ARM: davinci: enable SRAM ping ping buffering on
 DA850
Message-ID: <20121018151800.GB25164@beef>
References: <1349991229-32107-1-git-send-email-mporter@ti.com>
 <1349991229-32107-3-git-send-email-mporter@ti.com>
 <50784F2A.7080809@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50784F2A.7080809@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 07:11:06PM +0200, Sergei Shtylyov wrote:
> Hello.
> 
> On 11-10-2012 23:33, Matt Porter wrote:
> 
> >Passes the DA850 shared SRAM gen_pool to the McASP driver
> >and enables the ping-pong buffer DMA support.
> 
>    Here "ping-pong is correct but the subject have a typo.

Thanks.

Daniel: can you correct this when you squash these into your
series?

-Matt
