Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab0JFPRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:17:20 -0400
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:60454 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab0JFPRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:17:19 -0400
Message-ID: <4CAC92D3.2050700@csr.com>
Date: Wed, 06 Oct 2010 16:16:35 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-usb@vger.kernel.org, tlinder <tlinder@codeaurora.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Robert Lukassen <robert.lukassen@tomtom.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Fabien Chouteau <fabien.chouteau@barco.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/2] usb:gadget: Add SuperSpeed support to the Gadget
 Framework
References: <568203.56459.qm@web180308.mail.gq1.yahoo.com>
In-Reply-To: <568203.56459.qm@web180308.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2010 15:16:37.0648 (UTC) FILETIME=[786B9900:01CB6569]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> 
>> Support for new SuperSpeed BOS descriptor was 
> 
> Wireless USB BOS descriptors exist too, yes?  Does
> this approach cover them, or just SuperSpeed?  (We
> may someday want to support Wireless USB on the
> peripheral/gadget side too...

Wireless USB also has endpoint companion descriptors similar to SuperSpeed.

I haven't received the patch email for some reason.  If someone forwards
it to me I can review it from a WUSB point of view.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
