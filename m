Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1BJTjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:39:22 -0500
Received: from bosmailout13.eigbox.net ([66.96.189.13]:53235 "EHLO
	bosmailout13.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1BJTjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:39:20 -0500
X-Greylist: delayed 2379 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Feb 2011 14:39:20 EST
X-EN-OrigOutIP: 10.20.18.3
X-EN-IMPSID: 6JzY1g00503yW7601JzYA1
Message-ID: <4D543738.3080206@jaysonking.com>
Date: Thu, 10 Feb 2011 13:06:32 -0600
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Willy Tarreau <w@1wt.eu>
Subject: Re: Linux 2.6.27.58
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 67.65.251.18
X-EN-OrigHost: adsl-67-65-251-18.dsl.okcyok.swbell.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry if I missed CC'ing anyone, I'm not subscribed to the list)

Mike Galbraith wrote:
> For users of 27 who wish the scheduler had a bit less overhead,
> attached is a small set of sched patches I considered mandatory for
> my 27 tree. First patch cuts overhead quite a bit, the others are
> just fixes I considered important enough to carry around.

Mike,

Thanks for this patch set. I think it's a good idea.

Back in Dec 2008, we discussed a regression associated with the first
patch in this series, "sched: revert back to per-rq vruntime".

You proposed a fix which was committed as 0a582440 and then that was
followed by another fix by Lin Ming 6272d68c. Should these two
additional patches be included in the patch series above?

Jayson

