Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab0JHQpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 12:45:31 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20343 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab0JHQpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 12:45:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6130"; a="57199972"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
In-Reply-To: <20101008175636.766dd1f5@lxorguk.ukuu.org.uk>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
	 <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
	 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
	 <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTimxUAV1=cSJoZFbYiv8JLT+QT=OLEXynxaUtfOS@mail.gmail.com>
	 <1286486094.23836.59.camel@c-dwalke-linux.qualcomm.com>
	 <20101008091331.74871a42@lxorguk.ukuu.org.uk>
	 <1286551434.4153.21.camel@m0nster>
	 <20101008175636.766dd1f5@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 09:45:28 -0700
Message-ID: <1286556328.4153.142.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 17:56 +0100, Alan Cox wrote:
> > I'm assuming Hyok added this because it wasn't easy or possible to
> > change the file system .. I can imagine there are debugging situations
> > where that's true.
> 
> Well stop assuming. You cc'd Hyok so let him speak for himself if he
> cares about it and has an example.

I've been waiting, but he's not lightning fast responding it seems.

> > I don't think the kernel is going to implode if we allow an optional
> > ttyS override for debugging purposes.. I just don't see that "screwing"
> > up the kernel.
> 
> That is perhaps why you are not a subsystem maintainer.

No, I'm sure it's not.

What I was telling Greg is that this type of override is allowed right
now, if you mod the source (everything is allowed if you mod the source
right?) ..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


