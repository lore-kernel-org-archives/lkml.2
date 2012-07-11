Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab2GKNXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:23:55 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:42469 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753103Ab2GKNXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:23:53 -0400
Message-ID: <4FFD7E75.8090306@ti.com>
Date: Wed, 11 Jul 2012 15:24:05 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: SamuelOrtiz <sameo@linux.intel.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Remove unneeded io_mutex from struct twl6040
References: <1341972394.25495.3.camel@phoenix>
In-Reply-To: <1341972394.25495.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2012 04:06 AM, Axel Lin wrote:
> Current code has been converted to use regmap APIs, the io_mutex is not needed.
> Thus remove the io_mutex.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks for cleanup,

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>


