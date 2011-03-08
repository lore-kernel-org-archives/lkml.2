Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1CHPSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:18:35 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58057 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1CHPSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:18:34 -0500
Message-ID: <4D764873.2000007@mvista.com>
Date: Tue, 08 Mar 2011 18:17:07 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        "Kevin Hilman (supporter:TI DAVINCI MACHIN...,commit_signer:16/18=89%)" 
	<khilman@ti.com>,
        "Russell King (maintainer:ARM PORT)" <linux@arm.linux.org.uk>,
        "Michael Williamson (commit_signer:5/18=28%)" 
	<michael.williamson@criticallink.com>,
        "Sergei Shtylyov (commit_signer:3/18=17%)" <sshtylyov@ru.mvista.com>,
        "Cyril Chemparathy (commit_signer:3/18=17%)" <cyril@ti.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/7] da850: pruss platform specific additions.
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com> <1299592667-21367-3-git-send-email-subhasish@mistralsolutions.com>
In-Reply-To: <1299592667-21367-3-git-send-email-subhasish@mistralsolutions.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08.03.2011 16:57, Subhasish Ghosh wrote:

> This patch adds the platform device and assignes the platform resources
> for the PRUSS mfd driver.

    It also adds the PRUSS clock (which I'd have done in a sperate patch). I 
think I've already said that though...

> Signed-off-by: Subhasish Ghosh<subhasish@mistralsolutions.com>

WBR, Sergei
