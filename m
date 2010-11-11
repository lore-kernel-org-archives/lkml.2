Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab0KKGWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:22:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8004 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab0KKGWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:22:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6163"; a="61548724"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <tlinder@codeaurora.org>, "'David Brownell'" <david-b@pacbell.net>
Cc: <linux-usb@vger.kernel.org>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        "'Greg Kroah-Hartman'" <gregkh@suse.de>,
        "'Michal Nazarewicz'" <m.nazarewicz@samsung.com>,
        "'Randy Dunlap'" <randy.dunlap@oracle.com>,
        "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Robert Lukassen'" <robert.lukassen@tomtom.com>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        "'Matthew Wilcox'" <willy@linux.intel.com>,
        "'Fabien Chouteau'" <fabien.chouteau@barco.com>,
        "'Tejun Heo'" <tj@kernel.org>, <linux-kernel@vger.kernel.org>
References: <594730.42296.qm@web180308.mail.gq1.yahoo.com> <7d9b495656759bd678ed91212b279a6c.squirrel@www.codeaurora.org>
In-Reply-To: <7d9b495656759bd678ed91212b279a6c.squirrel@www.codeaurora.org>
Subject: RE: [RFC/PATCH 2/2 RESENd] usb:gadget: Add SuperSpeed support to the      Gadget Framework
Date: Thu, 11 Nov 2010 08:24:59 +0200
Message-ID: <001e01cb8169$2dc11990$89434cb0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: ActkXQZD6jtyt57RT3ixaFsI9H9YdwdDA9iQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending since not everyone received my reply.

-----Original Message-----
From: tlinder@codeaurora.org [mailto:tlinder@codeaurora.org] 
Sent: Tuesday, October 05, 2010 9:15 AM
To: David Brownell
Cc: linux-usb@vger.kernel.org; tlinder; David Brownell; Greg Kroah-Hartman;
Michal Nazarewicz; Randy Dunlap; Laurent Pinchart; Kyungmin Park; Robert
Lukassen; Sarah Sharp; Matthew Wilcox; Fabien Chouteau; Tejun Heo;
linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the
Gadget Framework

Hi Dave

We're currently working on USB Device Controller implementation. We
already have a working setup in our lab which these changes were verified
on. We passed USBCV 3.0 and 2.0 tests with this setup.
In parallel we added SuperSpeed support to the dummy_hcd module and tested
the patch using it as well. Changes to dummy_hcd will be release in a few
days.

Regards,
Tanya

I seem to have missed any posting of a SuperSpeed
> capable USB Device Controller driver, even as RFC.
>
> So these patches can't actually achieve what their
> subjects say.
>
> I'd rather hold off such interface changes until
> there's a orking vertical slice through the stack,
> complete enough to test and evaluate the changes.
>
> That said:  yes, propose the interface changes first
> before diving into the rest.
>
> - Dave
>
>
>
>
>


