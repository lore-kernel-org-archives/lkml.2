Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1K0K3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:29:42 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:49133 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1K0K3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:29:41 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Greg KH <greg@kroah.com>
Cc: dwmw2@infradead.org, dedekind1@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/16] mtd/docg3: add protection areas sysfs access
References: <1321714978-24543-1-git-send-email-robert.jarzmik@free.fr>
	<1321714978-24543-17-git-send-email-robert.jarzmik@free.fr>
	<20111126235727.GA12856@kroah.com>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 27 Nov 2011 11:29:28 +0100
In-Reply-To: <20111126235727.GA12856@kroah.com> (Greg KH's message of "Sat, 26
	Nov 2011 15:57:27 -0800")
Message-ID: <87r50t3lkn.fsf@free.fr>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Sat, Nov 19, 2011 at 04:02:58PM +0100, Robert Jarzmik wrote:
>> As each docg3 chip has 2 protection areas (DPS0 and DPS1),
>> and because theses areas can prevent user access to the chip
>> data, add for each floor the sysfs entries which insert the
>> protection key into the right DPS.
>> 
>> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
>
> As you are adding new sysfs files, you also must add Documentation/ABI
> entries for them.  Please do so.
OK Greg, I'll prepare a patch soon.

Cheers.

-- 
Robert
