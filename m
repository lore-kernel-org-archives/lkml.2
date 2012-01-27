Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2A0SyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:54:23 -0500
Received: from nm29.access.bullet.mail.mud.yahoo.com ([66.94.237.94]:48913
	"HELO nm29.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752772Ab2A0SyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:54:21 -0500
X-Yahoo-Newman-Id: 70692.91927.bm@smtp103.biz.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 2.5kCAQVM1lnmBS8ptnw9_HLvdtr1DwJ.XAO5.piaPHknrZ
 Bopv8lOglydVXclRqAPHL_0pKMPRIR7.lxVWL79qjNp.16kMRni15wYb7U6H
 PDO41qnLeyl6rQ4588pSsOJLuQQ69Ueedl_xY3o3GQBfy.LevKUJyE7aDX7O
 tRTyGx5n8ZjmU2gmzMBoWilCfIIs_GvI0L7dZUZv5s4GQHseNy0.OdP0.29S
 ett2eTs88_cDGNVvxrGsmQX4dMvwpGti9aL5Y6E7egqzBWF3eM.WKn35CLWY
 qEo5g5eauEy25gsWrDYlWD3uWlYplGUuzDGcWSTDW371ROX7kd46LDemOFXw
 hx5WMiRWqh1slU4T.8KABCl82rQyzJc15Jq8zFgxLqTqvu_J.E2b1hKpL9Tj
 ML1aH.ugUI9vuVA5Y.6XTThhW5db8
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F22F2D4.4080605@schaufler-ca.com>
Date: Fri, 27 Jan 2012 10:54:12 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Kees Cook <kees@ubuntu.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 0/4] AppArmor: refactor securityfs to use structures
References: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
In-Reply-To: <1327624163-21576-1-git-send-email-kees@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/26/2012 4:29 PM, Kees Cook wrote:
> This is the ground-work for expanding the AppArmor securityfs to include
> useful information that the userspace tools can more easily interact with.
> Presently, this is only static information about the state of AppArmor.

If you're making changes for securityfs do you suppose that
you might do all of us LSM developers a huge favor and add an
entry that reports the active LSM? It's something that has been
on my todo list for ages and would make everyone's life so much
easier. /sys/kernel/security/LSM which contains the name of the
active LSM would be very handy.


>
> -Kees
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

