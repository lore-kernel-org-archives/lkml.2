Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab1GHOYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:24:46 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58931 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab1GHOYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:24:45 -0400
Date: Fri, 8 Jul 2011 16:24:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg KH <gregkh@suse.de>
Cc: Drunkard Zhang <gongfan193@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: 2.6.39.2: duplicate filename '/devices/platform/GHES.9' on Asus
 DSBV-D
Message-ID: <20110708142453.GA15256@gere.osrc.amd.com>
References: <CAJiejCSObv6d2EULVnCufGMHsLacSi-g2o9gbs8p0MYoYMVgJg@mail.gmail.com>
 <20110708134003.GA5041@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708134003.GA5041@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 06:40:03AM -0700, Greg KH wrote:
> On Fri, Jul 08, 2011 at 04:02:27PM +0800, Drunkard Zhang wrote:
> > On newly updated kernel I found this. I'm not sure it's a BIOS bug or
> > kernel bug. More infomation attached. I can gather more infomation if
> > you want :)
> 
> It's an acpi issue, care to send it to that mailing list?

We had this issue already: http://lkml.org/lkml/2010/9/17/116 - I
guess the fix wasn't complete. And yes, it is a BIOS bug but the
kernel shouldn't OOPS just because BIOS programmers fell asleep on the
keyboard.

Adding some more people to Cc.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
