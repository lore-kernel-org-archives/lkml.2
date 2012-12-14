Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2LNTSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:18:36 -0500
Received: from smtp109.biz.mail.bf1.yahoo.com ([98.139.244.33]:35961 "HELO
	smtp109.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932143Ab2LNTSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:18:34 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CGM64S0VM1lr2GMFyz.EciBIF_vEJefqAHRI.qWO6QBJB.u
 rw2tz0xecFwSQNvlA4AvR_t8pEhA4VR_8BBDZbkdMFRxbwRH5hGSG4ENUCT7
 6TShziZFxIv6_X1Jq3HhjGHuAp9.SzAkfXCIPkRk7d211AVZQ2Ug2hgB8gg.
 MbXYSuhwmTr_fVKhbKSPYyHHRFWxEeto0CSF9LFj3q0dAX7sh6KYEaO.BtP4
 I_H0EmjkAMVPW59kwzj806ISh6V9kma0ehWOYwpVxVQP381Hn_3uA_pojmz9
 CQUpewmUgOjNW9UIM4SGTav3f60TixAfTeCNByUKAUEop9EUrlWhsPCYpNoU
 6VF4oGgIcMZOuejwyN2KdUo0Fvh_WZ9kgIZJeVCWeYiic2RfqA0Uy7XOoG8b
 NDpPHS0deds1fSHP9RjfSy0fk6S3QrTNzux5Yax7i9BfXoXeC.AnguIJoM5m
 Lbv4zGQyo.0Oof7Du5xnrHvAMAvpLBDV0VKdFgtvho1r_o8UaBim7FepJYI7
 nz4lhVJyIQvkdDaN_LeEVc4tLpJSg.9zc2eIo5gxLzMxrn3KLEFs7sfVB4Ki
 HJ2wcSrY5IjmyHxa3OvlUJkdQta6S02Me5lDLfENvrxU9Vptpih4FR7ptAKB
 4aDBhIArfJbjMeiF_OA0LmsJWMg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50CB7BBE.2040002@schaufler-ca.com>
Date: Fri, 14 Dec 2012 11:19:26 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PULL] Smack: Changes for 3.8 - after rebase
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3f0cc6ae86627de825d2371b6d61643f2ce58908:

  Merge tag 'yama-3.8' of git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux into next (2012-11-21 21:45:55 +1100)

are available in the git repository at:


  git://git.gitorious.org/smack-next/kernel.git for-james-20121214

for you to fetch changes up to e93072374112db9dc86635934ee761249be28370:

  Smack: create a sysfs mount point for smackfs (2012-12-14 10:57:23 -0800)

----------------------------------------------------------------
Casey Schaufler (2):
      Smack: use select not depends in Kconfig
      Smack: create a sysfs mount point for smackfs

 security/smack/Kconfig   |    6 +++++-
 security/smack/smackfs.c |   17 +++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

