Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab0G3Esa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:48:30 -0400
Received: from smtp108.prem.mail.sp1.yahoo.com ([98.136.44.63]:22711 "HELO
	smtp108.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751742Ab0G3Es3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:48:29 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: a2gGXb8VM1lZ15h7ziapDxbbLi9C3TA1MFYgboLsqn5H6ax
 1OgoVysY.LPca2g.TtMewEkBPur7o6GnNui5cAuCbxdHn6oOBW0DilS1Sfm4
 fum73gbhKKaensl_7HZew4WND_u_YAYHAgYqzZrWjO.JUzHwRwWkLtpnXiEn
 NyZIpo9FSMvL5lsLpicjjPSGsvjGUu3oIS0DEu_cGLtZVez8j0Lj2beaLOGs
 nGdjt6oDWgQMK40zaj1XiLlLTNvp82Cm1dF.OGQRrVczpDDUQgfr1uMEg4_X
 _acpsfAWaSp8DQO540y5mdRdRw_uinM6x_wd8slhgBLAf8Wj3hQWezdlR
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4C52599C.60907@schaufler-ca.com>
Date: Thu, 29 Jul 2010 21:48:28 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #7 0/13] AppArmor security module
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com> <alpine.LRH.2.00.1007300903440.7719@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1007300903440.7719@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Thu, 29 Jul 2010, John Johansen wrote:
>
>   
>> This is the seveth general posting of the newest version of the
>> AppArmor security module it has been rewritten to use the security_path
>> hooks instead of the previous vfs approach.  The current implementation
>> is aimed at being as semantically close to previous versions of AppArmor
>> as possible while using the existing LSM infrastructure.
>>     
>
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
>
> Please carry out any further development against the above tree.
>   

Now wasn't that an adventure?

