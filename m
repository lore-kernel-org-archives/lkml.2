Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0GLWot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:44:49 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42326 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab0GLWos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:44:48 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C3B9AD5.2070103@s5r6.in-berlin.de>
Date: Tue, 13 Jul 2010 00:44:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-kernel@vger.kernel.org, David Newall <davidn@davidnewall.com>,
        Marcin Letyns <mletyns@gmail.com>
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de> <4C3B585A.6090106@s5r6.in-berlin.de> <4C3B73D7.8050802@davidnewall.com> (sfid-20100712_220118_147710_090EA85C) <201007122340.06951.Martin@lichtvoll.de>
In-Reply-To: <201007122340.06951.Martin@lichtvoll.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> And when the combination of 2.6.33 now .6 and userspace software suspend 
> works for me - for the first time, often it was TuxOnIce that worked, but 
> not any in kernel method I tried from time to time - so be it for the time 
> being, even if userspace software suspend is way slower and doesn't 
> satisfy the disk on writing the image.

BTW, the need to rely on a quite fundamental kernel component that is
not in the mainline (for whichever reason) in the long term, almost
guarantees you a lot of recurring pain, one way or another.
-- 
Stefan Richter
-=====-==-=- -=== -==-=
http://arcgraph.de/sr/
