Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab0JHPch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:32:37 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44550 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab0JHPcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:32:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6129"; a="57191876"
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
From: Daniel Walker <dwalker@codeaurora.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Mike Frysinger <vapier@gentoo.org>, Feng Tang <feng.tang@intel.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
In-Reply-To: <20101008091826.03cdff76@lxorguk.ukuu.org.uk>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
	 <20101007215019.17b4a34a@lxorguk.ukuu.org.uk>
	 <1286483766.23836.39.camel@c-dwalke-linux.qualcomm.com>
	 <20101007220538.2294a7e4@lxorguk.ukuu.org.uk>
	 <1286484678.23836.49.camel@c-dwalke-linux.qualcomm.com>
	 <20101007223819.46246716@lxorguk.ukuu.org.uk>
	 <1286487718.23836.94.camel@c-dwalke-linux.qualcomm.com>
	 <20101008091826.03cdff76@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 08:16:28 -0700
Message-ID: <1286550988.4153.6.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 09:18 +0100, Alan Cox wrote:
> > > - Submit a driver that uses the existing allocated jtag major/minor only
> > 
> > The driver does this already. It uses ttyJ* by default, and ttyS is an
> > option ..
> 
> It didn't seem to be using the correct major/minor however ?

yeah, it looks like it. ttyJ was registered specifically for this
driver..

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


