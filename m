Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0IPGV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:21:59 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:46117 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752525Ab0IPGV6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:21:58 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 02:21:57 EDT
MIME-Version: 1.0
In-Reply-To: <20100916060520.GA3393@legolas.emea.dhcp.ti.com>
References: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com>
 <20100915105641.GO3393@legolas.emea.dhcp.ti.com> <AANLkTi=gYSsxSHqAur+isj_UinVLC-YWkdmi5j_vkSUV@mail.gmail.com>
 <20100915110745.GP3393@legolas.emea.dhcp.ti.com> <4C90C5B7.7050103@ru.mvista.com>
 <20100916060520.GA3393@legolas.emea.dhcp.ti.com>
From: "Gadiyar, Anand" <gadiyar@ti.com>
Date: Thu, 16 Sep 2010 11:45:32 +0530
Message-ID: <AANLkTi=y-HfvDOvhW-WhLFq5TUCjGA-52cuyByCHMvvV@mail.gmail.com>
Subject: Re: [Discussion] USB: musb-gadget: how to fix ZLP issue in musb_g_tx
To: balbi@ti.com
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Ming Lei <tom.leiming@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 11:35 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Sep 15, 2010 at 08:10:15AM -0500, Sergei Shtylyov wrote:
>>
>>   I don't see what to rework. The last short packet should still satisfy
>> (request->actual == request->length) condition, no?
>
> of course not, it's short not zero. so the last short packet can be
> anything from 1 to 511 bytes.
>

If it's TX, both condtions should automatically be true, right?

- Anand
