Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0CRIiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 04:38:06 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59555 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab0CRIiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 04:38:04 -0400
X-Auth-Info: 4TOwoNFA7Th3Fyk5yUzfX+b9nU2qmjON92X9iTchyhs=
Message-ID: <4BA1E609.1010401@grandegger.com>
Date: Thu, 18 Mar 2010 09:36:25 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN module
References: <1267564929-9324-1-git-send-email-iws@ovro.caltech.edu>	<1267564929-9324-3-git-send-email-iws@ovro.caltech.edu> <20100317193312.GF9783@ovro.caltech.edu>
In-Reply-To: <20100317193312.GF9783@ovro.caltech.edu>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ira,

Ira W. Snyder wrote:
> Hello SocketCAN folks,
> 
> Is there any feedback on this patch? I've waited two weeks without a
> response to any part of the series. As this is the biggest patch in the
> series, if you're fine with it, I think the other supporting patches
> should be fairly uncontroversial.

For some strange reason this patch did not show up in my socketcan mbox,
sorry. At least I cannot find it. Oliver, or somebody else, did you
receive it? Nevertheless, for kernel inclusion the patch should go
through the netdev mailing list as described in:

http://svn.berlios.de/svnroot/repos/socketcan/trunk/README.submitting-patches

It's also confusing that one 2/3 shows up on the Socketcan-core ML. At
least 0/3 should also be presented there.

Could you please resubmit?

Wolfgang.
