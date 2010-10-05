Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab0JEHPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:15:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10559 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0JEHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:15:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6126"; a="56623800"
Message-ID: <7d9b495656759bd678ed91212b279a6c.squirrel@www.codeaurora.org>
In-Reply-To: <594730.42296.qm@web180308.mail.gq1.yahoo.com>
References: <594730.42296.qm@web180308.mail.gq1.yahoo.com>
Date: Tue, 5 Oct 2010 00:15:01 -0700 (PDT)
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the 
     Gadget Framework
From: tlinder@codeaurora.org
To: "David Brownell" <david-b@pacbell.net>
Cc: linux-usb@vger.kernel.org, "tlinder" <tlinder@codeaurora.org>,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Robert Lukassen" <robert.lukassen@tomtom.com>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Matthew Wilcox" <willy@linux.intel.com>,
        "Fabien Chouteau" <fabien.chouteau@barco.com>,
        "Tejun Heo" <tj@kernel.org>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


