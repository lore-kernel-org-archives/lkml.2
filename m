Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab1CIIWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 03:22:52 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:53946 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab1CIIWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 03:22:51 -0500
Date: Wed, 9 Mar 2011 10:23:01 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@iki.fi>
X-X-Sender: aaro@loser
To: Dan Carpenter <error27@gmail.com>
cc: Aaro Koskinen <aaro.koskinen@iki.fi>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: Re: [PATCH 06/15] staging: xgifb: delete bIntegratedMMEnabled
In-Reply-To: <20110308223620.GD3416@bicker>
Message-ID: <alpine.DEB.1.10.1103091014430.12072@loser>
References: <1299615380-22922-1-git-send-email-aaro.koskinen@iki.fi> <1299615380-22922-7-git-send-email-aaro.koskinen@iki.fi> <20110308223620.GD3416@bicker>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 9 Mar 2011, Dan Carpenter wrote:
> On Tue, Mar 08, 2011 at 10:16:11PM +0200, Aaro Koskinen wrote:
>> bIntegratedMMEnabled is always true, so the field and checks can be
>> eliminated.
>>
> What about for the chips that came before the XG40?  Are we dropping
> support for them?

They were never supported. See the earlier switch (xgi_video_info.chip_id)
statement in the probe routine - it will return -ENODEV for other chips
than XG40..XG27.

A.
