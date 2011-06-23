Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180Ab1FWJym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 05:54:42 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64548 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959Ab1FWJyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 05:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=eezEuUUM5/kV1eLuVDBQHxhSbkcCY+0N3xqt5GrrOfMYUfcrfZVIsjfo3lMIHHIcAO
         n+skezq1FxC3Zmqh4FvQq3XcieWJIjAiaTtZEBv1t5SXRIIGF4z+l9Qnwo4C56oKgI3S
         j8+BJFg9y5XqCF14afA+Crt8PegzZKTs82tao=
MIME-Version: 1.0
In-Reply-To: <1308820255.2737.70443.camel@needafix>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
 <4E025D39.80600@zytor.com> <1308820255.2737.70443.camel@needafix>
From: Julius Baxter <juliusbaxter@gmail.com>
Date: Thu, 23 Jun 2011 11:54:17 +0200
Message-ID: <BANLkTi=7Qfc2BBQrqv08A1N6O4aB0gmKyQ@mail.gmail.com>
Subject: Re: OpenRISC Architecture: Request for review
To: Jonas Bonn <jonas@southpole.se>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Do you also have any ready-made ports for any common FPGA boards that
>> one can test it out on hardware with?

Hi, thanks for the interest.

At present, there's two main projects that have OpenRISC-based system
builds for FPGA boards.

These builds typically contain, at least, the processor core, debug
interface, memory controller and a UART. That should be enough to get
you going. In terms of hardware, in addition to the board, you will
need a debug cable, allowing you to control the processor and access
the memory from gdb.

ORPSoC, or the OpenRISC Reference Platform System-on-Chip, is one
project with ready-to-go builds. It currently supports a few boards,
two Xilinx and one Actel. You can find details about them at the
ORPSoC page:

http://opencores.org/or1k/ORPSoC

MinSoC is another project on OpenCores that supports more boards, but
isn't something I've used myself. It looks well maintained, though.

http://opencores.org/project,minsoc

Their wiki is at:

http://minsoc.wikaba.com/pm:start

I believe MinSoC might have better step-by-step instructions for
getting going on the board.

The ORPSoC maintainers, though, are usually very easy to get hold of in IRC.

Hope that's useful.

    Julius
