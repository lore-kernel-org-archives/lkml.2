Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2GOMhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 08:37:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43108 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2GOMhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 08:37:43 -0400
Message-ID: <1342355859.23866.17.camel@chumley>
Subject: Re: [RFC 1/2] PCI-Express Non-Transparent Bridge Support
From: David Hagood <david.hagood@gmail.com>
To: Jon Mason <jon.mason@intel.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>
Date: Sun, 15 Jul 2012 07:37:39 -0500
In-Reply-To: <20120714061953.GD4808@jonmason-lab>
References: <1342215900-3358-1-git-send-email-jon.mason@intel.com>
	 <20120713171344.1066d3b1@nehalam.linuxnetplumber.net>
	 <20120714061953.GD4808@jonmason-lab>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you looked at any of the work that the PXI group has done on NTB
support within PXI?
http://www.ni.com/white-paper/12523/en

I was on that working group, and one of the first capabilities I
suggested for it was IP over NTB - I was going to implement this at my
employer, but the project took a different turn and this idea got put on
the back burner. I am glad somebody else has seen fit to take it up.

Also, a stupid question but one I have to ask: have you taken into
account the idea that the CPUs on each side of the NTB might have
different endian-ness? I was looking at a case with a PPC on one side of
the bridge and an X86 on the other.


