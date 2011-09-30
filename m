Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab1I3KzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 06:55:08 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57044 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755484Ab1I3KzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 06:55:06 -0400
X-Sasl-enc: bRSxY58OqZ/tfQgJpu0Jbp5uOu/B1OLAt9FQfvdhUKrE 1317380104
Message-ID: <4E85A03A.4030200@ladisch.de>
Date: Fri, 30 Sep 2011 12:55:54 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: dmarkh@cfl.rr.com
CC: markh@compro.net, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problem with AMD chipsets. Was "Re: problems doing direct dma
 from a pci device to pci-e device"
References: <4E84CA01.2060907@compro.net> <4E84D55A.5050406@compro.net> <4E858200.8070302@ladisch.de> <4E859529.2020504@cfl.rr.com>
In-Reply-To: <4E859529.2020504@cfl.rr.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> I wonder what they expect you to get out of "P2P traffic _could_ be only
> memory writes" Does that mean it _can_ be configured as "P2P traffic is
> enabled for only writes"? In any case I can do neither reads or writes.

AFAICT you won't be able to do P2P reads in any case.

> As for the MISC bits described in the BDG, it appears that by default all
> the P2PDIS bits will be set to 0. Are there tools that would enable me to
> look at these bits and even change them if they are set.

setpci


Regards,
Clemens
