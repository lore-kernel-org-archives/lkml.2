Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1JNJ1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:27:10 -0400
Received: from ezo.ezono.com ([50.22.105.208]:43352 "EHLO ezo.ezono.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab1JNJ1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:27:08 -0400
Message-ID: <4E980065.3090509@ezono.com>
Date: Fri, 14 Oct 2011 11:27:01 +0200
From: Abdelghani Ouchabane <abdelghani@ezono.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com> <4E8F2758.3040408@ezono.com> <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com> <4E93FA07.306@ezono.com> <CAErSpo7c8pgBUxLGC5rKrBbkSsf+MSGhXuEZAyrPkRj8X2YpBA@mail.gmail.com> <4E954251.5020801@ezono.com> <4E9549E5.4090405@ezono.com> <CAErSpo5Q22-VtNd23-rmCUsJdQmN7VdmSAM806-_Po7=KK9Y0g@mail.gmail.com>
In-Reply-To: <CAErSpo5Q22-VtNd23-rmCUsJdQmN7VdmSAM806-_Po7=KK9Y0g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ezo.ezono.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ezono.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thanks for the details.
>
> If I understand correctly:
>
>    A - fails (card not present at power-on, added later)
>    B - works (card always present)
>    C - works (card present at power-on, later removed and re-added,
> requires manual rescan)
>
> I see this note in section 9.4.8 (BIOS setup) of the conga-BAF User's Guide:
>
>      Note: Unless the hotplug support for this port is enabled as well,
> an unpopulated
>      port will still be disabled if no PCI Express device is connected.
>
> If you don't have hotplug enabled in the BIOS setup, it sounds like it
> might result in the behavior you're seeing.  Do you have that enabled?
>
> Bjorn

Hallo Bjorn & Kenji,

    the hot-plug was enabled, but today I have received a new BIOS from 
Congatec which solves the problem.

Among the fix is:

_BBRAR009 to BBRAR110:_

2. Enabled PCIExpress / ExpressCard basic hotplug support. Enabled event 
handling support.

Now after the manual rescan my FPGA board gets detect correctly and I 
can access its registers in the correct way.


Many thanks for all your supports.

My best regards,
Ghani



