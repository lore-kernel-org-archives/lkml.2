Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab0GAQWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:22:52 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45731 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775Ab0GAQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:22:51 -0400
X-Sasl-enc: pvDtvJv9Emm0tiNZfxwY2WGL2HMglBs7QUW/q6pFGsjw 1278001362
Date: Thu, 1 Jul 2010 13:22:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de
Subject: Re: Provide /sys/../ec with read/write access and some cleanups
Message-ID: <20100701162239.GB4789@khazad-dum.debian.net>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277996570-2686-1-git-send-email-trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jul 2010, Thomas Renninger wrote:
> These patches are diffed against the test branch of the ACPI tree, but also
> patch fine with 2.6.35-rc3.
> 
> I thought about tainting the kernel if someone writes to the EC, but as
> userspace can also write to graphics IO, PCI config or MSRs, it shouldn't
> matter that much.
> Eventually this should still be added (by a separate patch), one can easily
> confuse the EC to not switch on the fans anymore.
> 
> A small tool to read out and write to /sys/devices/system/ec/*/io can be
> found here:
> ftp://ftp.suse.com/pub/people/trenn/sources/ec/ec_access.c
> 
> Len: Can you apply these into your test branch and schedule them for linux-next
> and 2.6.36 if there are no objections, please.

I am just wondering if we shouldn't have this in debugfs instead of regular
/sys.  Do you envision *production* use of this facility, or should it just
be something to use for debugging and hacking?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
