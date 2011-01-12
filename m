Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1ALOfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:35:31 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:39257 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1ALOf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:35:29 -0500
Message-ID: <4D2DBC2C.6070301@de.ibm.com>
Date: Wed, 12 Jan 2011 15:35:24 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100918 Lightning/1.0b2 Icedove/3.1.4
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Anca Emanuel <anca.emanuel@gmail.com>, Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm for rc1
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com> <4D2D8ED0.6080807@de.ibm.com> <AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com> <alpine.LFD.2.00.1101121344070.8212@casper.infradead.org>
In-Reply-To: <alpine.LFD.2.00.1101121344070.8212@casper.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.01.2011 14:45, schrieb James Simmons:
>> I tested the revert: the boot screen did change the resolution
>> (without it don't), but my PC still hangs. (using an nvidia 8800GT).
> 
> Try my most recent patch. Where does it hang at? Any logs?

FYI, I just want to mention that with the latest git+the fix 
X11 sometimes consumes 100% cpu for a long time. Dont know if
this is a related problem or not.

Christian

