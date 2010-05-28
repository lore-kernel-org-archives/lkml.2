Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab0E1Qkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 12:40:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52680 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab0E1Qkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 12:40:33 -0400
Message-ID: <4BFFEFA1.1020307@zytor.com>
Date: Fri, 28 May 2010 09:30:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH V3] x86, UV: BAU performance and error recovery
References: <E1OHzgl-0000Pj-6o@eag09.americas.sgi.com>
In-Reply-To: <E1OHzgl-0000Pj-6o@eag09.americas.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2010 06:33 AM, Cliff Wickman wrote:
> - adds modification of tuning variables through /proc/sgi_uv

Adding new directories in /proc for a proprietary architecture is
frowned upon, to put it mildly.  At the very least try to find a place
in sysfs for it.

[Cc: gregkh in order to find a place in sysfs]

The other thing, please don't mix bug fixes and new features.  They
should be separate features.

	-hpa
