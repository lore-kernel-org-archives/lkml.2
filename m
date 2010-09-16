Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab0IPGFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:05:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42505 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab0IPGFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:05:41 -0400
Date: Thu, 16 Sep 2010 09:05:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: "Balbi, Felipe" <balbi@ti.com>, Ming Lei <tom.leiming@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [Discussion] USB: musb-gadget: how to fix ZLP issue in
 musb_g_tx
Message-ID: <20100916060520.GA3393@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com>
 <20100915105641.GO3393@legolas.emea.dhcp.ti.com>
 <AANLkTi=gYSsxSHqAur+isj_UinVLC-YWkdmi5j_vkSUV@mail.gmail.com>
 <20100915110745.GP3393@legolas.emea.dhcp.ti.com>
 <4C90C5B7.7050103@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4C90C5B7.7050103@ru.mvista.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 15, 2010 at 08:10:15AM -0500, Sergei Shtylyov wrote:
>    I don't see what to rework. The last short packet should still satisfy
>(request->actual == request->length) condition, no?

of course not, it's short not zero. so the last short packet can be
anything from 1 to 511 bytes.

-- 
balbi
