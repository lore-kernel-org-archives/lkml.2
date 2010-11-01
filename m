Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab0KATEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:04:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44371 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab0KATEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:04:43 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CCF0F38.3030106@s5r6.in-berlin.de>
Date: Mon, 01 Nov 2010 20:04:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Lukas Czerner <lczerner@redhat.com>
CC: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>
Subject: Re: ext4_lazyinit_thread: 'ret' may be used uninitialized in this
 function
References: <tkrat.ba371a0ea018042b@s5r6.in-berlin.de> <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1011011551001.2876@dhcp-lab-213.englab.brq.redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner wrote:
> thank you for noticing this, because I actually do not see the warning
> (I wonder why...),

Probably because of different gcc versions.  Here: 4.3.4
-- 
Stefan Richter
-=====-==-=- =-== ----=
http://arcgraph.de/sr/
