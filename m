Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab1CBSTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 13:19:12 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:40082 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab1CBSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 13:19:10 -0500
Date: Wed, 2 Mar 2011 20:19:11 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@iki.fi>
X-X-Sender: aaro@loser
To: Greg KH <greg@kroah.com>
cc: Aaro Koskinen <aaro.koskinen@iki.fi>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: Re: [RFC PATCH] staging: xgifb: remove private ioctls
In-Reply-To: <20110302153132.GA7325@kroah.com>
Message-ID: <alpine.DEB.1.10.1103021931550.3526@loser>
References: <1299016212-1060-1-git-send-email-aaro.koskinen@iki.fi> <20110302153132.GA7325@kroah.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2 Mar 2011, Greg KH wrote:
> On Tue, Mar 01, 2011 at 11:50:12PM +0200, Aaro Koskinen wrote:
>> Drop the badly defined and broken private ioctl interface. Since the
>> driver is in staging, and some of the ioctls are clearly unsafe or not
>> even working, it's unlikely that there are any users.
>>
>> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>
> Is this just a RFC, or do you want me to apply this patch?

I wasn't sure if we should try to retain all the interfaces the driver
provides. But if there are no objections, please apply, it will help a
lot with further cleanups.

A.
