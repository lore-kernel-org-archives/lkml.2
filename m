Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab1BKSmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:42:54 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57965 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab1BKSmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:42:50 -0500
Message-ID: <4D5582D1.9040005@mvista.com>
Date: Fri, 11 Feb 2011 21:41:21 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        "Kevin Hilman (supporter:TI DAVINCI MACHIN...,commit_signer:16/18=89%)" 
	<khilman@deeprootsystems.com>,
        "Russell King (maintainer:ARM PORT)" <linux@arm.linux.org.uk>,
        "Michael Williamson (commit_signer:5/18=28%)" 
	<michael.williamson@criticallink.com>,
        "Cyril Chemparathy (commit_signer:3/18=17%)" <cyril@ti.com>,
        "Sergei Shtylyov (commit_signer:3/18=17%)" <sshtylyov@ru.mvista.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/13] da850: pruss platform specific additions.
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-3-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1297435892-28278-3-git-send-email-subhasish@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Subhasish Ghosh wrote:

> This patch adds the platform device and assignes the platform resources
> for the PRUSS mfd driver.

    You also add the PRUSS clock (and I would have done that as a separate patch).

> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>

    You should have noted the patch dependency here -- this patch depends on the 
one nenaming DA8XX_LPSC0_DMAX.

WBR, Sergei
