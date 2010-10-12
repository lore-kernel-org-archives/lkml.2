Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab0JLJRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:17:54 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53047 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621Ab0JLJRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:17:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6133"; a="57570888"
Message-ID: <ebd4fd160630977be43d374147f5a7bf.squirrel@www.codeaurora.org>
In-Reply-To: <1286766418.2008.230.camel@helium>
References: <1286092937-29191-1-git-send-email-tlinder@codeaurora.org>
    <20101004072602.GB2256@xanatos>
    <0daac081a669f0cc8e024644f223c0c2.squirrel@www.codeaurora.org>
    <20101005181126.GB7383@xanatos>
    <207c0a821ef60e21a605f0b45c2d3777.squirrel@www.codeaurora.org>
    <1286766418.2008.230.camel@helium>
Date: Tue, 12 Oct 2010 02:17:44 -0700 (PDT)
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the  
     Gadget Framework
From: "Brokhman Tatyana" <tlinder@codeaurora.org>
To: "David Brownell" <david-b@pacbell.net>
Cc: tlinder@codeaurora.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        linux-usb@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Michal Nazarewicz" <m.nazarewicz@samsung.com>,
        "Randy Dunlap" <randy.dunlap@oracle.com>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Robert Lukassen" <robert.lukassen@tomtom.com>,
        "Matthew Wilcox" <willy@linux.intel.com>,
        "Fabien Chouteau" <fabien.chouteau@barco.com>,
        "Tejun Heo" <tj@kernel.org>, linux-kernel@vger.kernel.org
Reply-To: tlinder@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
>> > Ok.  I suppose whatever gadget application is being used can reset
>> these
>> > values later?  So that if you had a gadget webcam, it could set the
>> > wMaxPacketSize to the frame size or whatever it needed?
>
> Yes ... in fact, every altsetting or configuration may need to set up
> each endpoint differently ... that's why ep_enable() passes full
> endpoint configs (as descriptors), so they can more easily be changed.
>
> If the notion is that there are values that may need to get passed from
> silicon to driver, I'd like to see that done explicitly, with drivers
> updating descriptors, instead of doing anything by back-door routes
> that make UDC drivers making hidden updates.
>
> - Dave

This implementation creates default SuperSpeed descriptors with default
values. It is used to spare drivers that don't want to fully exploit
SuperSpeed functionality from handling SupperSpeed descriptors and still
be able to operate in a SupperSpeed mode.
Please note that the gadget driver can still provide SuperSpeed
descriptors with correct (and not default values) if it wishes to.
I hope I understood your comment correctly. Please let me know if this is
not the case.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


