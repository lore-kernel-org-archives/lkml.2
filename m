Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab0D0NZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:25:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:49044 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab0D0NZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:25:30 -0400
Date: Tue, 27 Apr 2010 15:25:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Oliver Neukum <oliver@neukum.org>, Marcel Holtmann <marcel@holtmann.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Nicu Pavel <npavel@ituner.com>,
       Jaya Kumar <jayakumar.lkml@gmail.com>,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>
Subject: Re: [PATCH 1/2] hid: add suspend/resume hooks for hid drivers
In-Reply-To: <20100425214003.7e87c6a3@neptune.home>
Message-ID: <alpine.LNX.2.00.1004271525090.9849@pobox.suse.cz>
References: <20100425214003.7e87c6a3@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Apr 2010, Bruno Prémont wrote:

> Add suspend/resume hooks for HID drivers so these can do some
> additional state adjustment when device gets suspended/resumed.
> 
> v3:
>   - Pass full message to hid driver's suspend hook
> v2:
>   - Adds auto_suspend parameter to suspend hook
>   - Only calls HID driver's resume hooks when previous code
>     did succeed
> 

I have applied this to 'hid-suspend' branch of my tree for now. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
