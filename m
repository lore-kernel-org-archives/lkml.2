Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2FRQhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:37:33 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51550 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2FRQhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:37:32 -0400
Message-ID: <4FDF5939.3090309@ti.com>
Date: Mon, 18 Jun 2012 22:07:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Kevin Hilman <khilman@ti.com>, Russell King <linux@arm.linux.org.uk>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: davinci: remove dummy header files
References: <1339618490.30984.178.camel@x61.thuisdomein>
In-Reply-To: <1339618490.30984.178.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 6/14/2012 1:44 AM, Paul Bolle wrote:
> These dummy headers are unused. Commit
> 6ea96e111e6a7f06ef62227bf64e8cd65bd705b3 ("ARM: davinci: add back dummy
> header files") only added them as a temporary measure. They can be
> removed now.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---

Queuing this for v3.6

Thanks,
Sekhar
