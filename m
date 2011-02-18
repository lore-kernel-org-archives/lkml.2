Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1BRHRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 02:17:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49613 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1BRHR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 02:17:29 -0500
Message-ID: <6C4C94BAB9814DDB9D0500AF2BA1A319@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Sergei Shtylyov" <sshtylyov@mvista.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "Kevin Hilman \(supporter:TI DAVINCI MACHIN...,commit_signer:16/18=89%\)" 
	<khilman@deeprootsystems.com>,
        "Russell King \(maintainer:ARM PORT\)" <linux@arm.linux.org.uk>,
        "Michael Williamson \(commit_signer:5/18=28%\)" 
	<michael.williamson@criticallink.com>,
        "Cyril Chemparathy \(commit_signer:3/18=17%\)" <cyril@ti.com>,
        "Sergei Shtylyov \(commit_signer:3/18=17%\)" 
	<sshtylyov@ru.mvista.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com> <1297435892-28278-3-git-send-email-subhasish@mistralsolutions.com> <4D5582D1.9040005@mvista.com>
In-Reply-To: <4D5582D1.9040005@mvista.com>
Subject: Re: [PATCH v2 02/13] da850: pruss platform specific additions.
Date: Fri, 18 Feb 2011 12:48:30 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------------------------------------
From: "Sergei Shtylyov" <sshtylyov@mvista.com>
Sent: Saturday, February 12, 2011 12:11 AM
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>; 
<linux-arm-kernel@lists.infradead.org>; <m-watkins@ti.com>; 
<nsekhar@ti.com>; <sachi@mistralsolutions.com>; "Kevin Hilman (supporter:TI 
DAVINCI MACHIN...,commit_signer:16/18=89%)" <khilman@deeprootsystems.com>; 
"Russell King (maintainer:ARM PORT)" <linux@arm.linux.org.uk>; "Michael 
Williamson (commit_signer:5/18=28%)" <michael.williamson@criticallink.com>; 
"Cyril Chemparathy (commit_signer:3/18=17%)" <cyril@ti.com>; "Sergei 
Shtylyov (commit_signer:3/18=17%)" <sshtylyov@ru.mvista.com>; "open list" 
<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/13] da850: pruss platform specific additions.

> Hello.
>
> Subhasish Ghosh wrote:
>
>> This patch adds the platform device and assignes the platform resources
>> for the PRUSS mfd driver.
>
>    You also add the PRUSS clock (and I would have done that as a separate 
> patch).
>
>> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
>
>    You should have noted the patch dependency here -- this patch depends 
> on the one nenaming DA8XX_LPSC0_DMAX.

SG - Will do
>
> WBR, Sergei 

