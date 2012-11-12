Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2KLELR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 23:11:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab2KLELP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 23:11:15 -0500
Message-ID: <50A07768.5010704@redhat.com>
Date: Sun, 11 Nov 2012 23:13:28 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Luming Yu <luming.yu@gmail.com>
CC: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH update 0/3] HW-latency: hardware latency test 0.10
References: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
In-Reply-To: <1352602102-2390-1-git-send-email-luming.yu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2012 09:48 PM, Luming Yu wrote:

> Update the previous patch series to ACK all comments I've recevied so far
> for the tool: e.g. 1.Acked Jon Masters in source code as many code are from
> jcm, thanks very much Jon. 2. squashed all changes against new file I added into
> one. 3. Make it useful on non-x86.

Thanks for taking this and doing the heavy lifting to get it upstream! I
wrote the original SMI detector really for RT debug purposes as we had
OEM systems that would generate large latencies and it was easier to
prove the point with nice graphs showing where the BIOS was injecting
unwanted SMIs. Glad to see the work being done to make it more generic
in nature. Maybe I'll come back with some ARM patches ;)

Actually this exercise was very informative because it has helped shape
my input on ARMv8 designs. I'm very keen to get away from a world in
which world+dog feature is implemented inside an SMI-like context. It
should be done via a dedicated management processor (on-chip) instead.

Jon.

