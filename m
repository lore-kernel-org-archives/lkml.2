Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab1BIXpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:45:13 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:42843 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755920Ab1BIXpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:45:11 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: m51ParMVM1l_svCuW7e276t3WwtC9cpGXc8EFs7DgGDvGXv
 YXwIsMnUg4LA1V2GlqN_x_r6HoNuixIcEzJSMcw45Br8WMeu5aHY8V59DrAn
 xErZZiobgWVr2aVARaVQGnf3Y5q7sqKvqO6_A0buDkiHFFGzpmZ0mFAWpP3L
 qWYDaMwJdlseTeYwJ0GnySVtPB_zA8_5Au.0jp3iq0azLVXc81RTvsNTocyp
 qcYxS2T0cgnQHz2BIwHdSHYAs9u2XTVBhnBN82rI_WGc_gfiI5n7Dex6OX7j
 3HxjFlJUK.XwQfnfcerMZZHp3Tg0BJvinBDK32pXIUNO09DGv9Hapb5Zn1c1
 gPoSY1QMGRUZyTQ5e0BjdMCcQlJicYj9.mIFvHt16ZplltA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D532703.9060306@schaufler-ca.com>
Date: Wed, 09 Feb 2011 15:45:07 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Sakkinen Jarkko.2 \(EXT-Tieto/Tampere\)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena \(Nokia-D/Helsinki\)" <elena.reshetova@nokia.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Subject: [PATCH] Smack: mmap controls for library containment
References: <4D346C8E.3080408@schaufler-ca.com> <4D51E188.9090008@schaufler-ca.com> <alpine.LRH.2.00.1102091851030.12310@tundra.namei.org> <4D52936A.6010407@schaufler-ca.com> <alpine.LRH.2.00.1102100852180.18248@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1102100852180.18248@tundra.namei.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/2011 1:53 PM, James Morris wrote:
> On Wed, 9 Feb 2011, Casey Schaufler wrote:
>
>>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>>> Applied to
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
>>>
>> James, I made an error and failed to say that this and Shan Wei's clean-up
>> should be pulled from git://gitorious.org/smack-next/kernel.git
> Please use git-request-pull to generate the message.
The following changes since commit 7898e1f8e9eb1bee88c92d636e0ab93f2cbe31c6:
  Casey Schaufler (1):
        Subject: [PATCH] Smack: mmap controls for library containment

are available in the git repository at:

  git://gitorious.org/smack-next/kernel.git master

Casey Schaufler (2):
      Smack: correct behavior in the mmap hook
      Smack: correct final mmap check comparison

Shan Wei (1):
      security:smack: kill unused SMACK_LIST_MAX, MAY_ANY and MAY_ANYWRITE

 security/smack/smack.h     |    8 ----
 security/smack/smack_lsm.c |   85 +++++++++++++++++++++++++------------------
 2 files changed, 49 insertions(+), 44 deletions(-)



