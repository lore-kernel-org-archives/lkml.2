Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2GEFVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 01:21:24 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:56625 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2GEFVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 01:21:15 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApFYAJwj9U9V5qg+PGdsb2JhbABFihqtDhkBAQEBHgMWDSeCGAEBBTocEwEPEAgDGC4UJQoaE4gPuggUiyWFXmADlTaFZox/
X-IronPort-AV: E=Sophos;i="4.77,528,1336341600"; 
   d="scan'208";a="368483477"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 5 Jul 2012 07:21:41 +0200
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Henrik Rydberg <rydberg@bitmath.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr,
        benjamin.tissoires@gmail.com, peter.hutterer@who-t.net,
        chasedouglas@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: MT - Include win8 support
Message-ID: <20120705052141.GA977@polaris.bitmath.org>
References: <1340785690-13652-1-git-send-email-rydberg@euromail.se>
 <20120703175842.GA472@polaris.bitmath.org>
 <4FF3956C.7020608@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3956C.7020608@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 05:59:24PM -0700, Chase Douglas wrote:
> On 07/03/2012 10:58 AM, Henrik Rydberg wrote:
> >On Wed, Jun 27, 2012 at 10:28:10AM +0200, Henrik Rydberg wrote:
> >>The newly released HID protocol for win8 multitouch devices is capable
> >>of transmitting more information about each touch. In particular, it
> >>includes details useful for touch alignment. This patch completes the
> >>MT protocol with the ABS_MT_TOOL_X/Y events, and documents how to map
> >>win8 devices.
> >>
> >>Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> >>---
> >>Hi all,
> >>
> >>Here is the patch following the RFC on win8 MT support. An ascii-art
> >>version of the figure has been included, Peter's orientation text is
> >>there, and the usage section has been extended with more semantics and
> >>mappings. Hopefully the similarities and differences between the
> >>models are clearer now. Also, the usage of azimuth has been left out,
> >>awaiting an actual device using it.
> >
> >I would like to have a couple of ACK's on this patch, if
> >possible. Please? :-)
> 
> I read it through and let it sit a bit to try to figure out if there
> were any issues I could see. I don't see any, so:
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>

Applied and pushed. Thank you, Chase.

Henrik
