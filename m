Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1HRH76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:59:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62592 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755264Ab1HRH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:59:57 -0400
Message-ID: <4E4CB291.5010102@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 14:34:57 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: JJ Ding <jj_ding@emc.com.tw>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 5/6] Input: elantech - clean up elantech_init
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-6-git-send-email-jj_ding@emc.com.tw>
In-Reply-To: <1313632629-23603-6-git-send-email-jj_ding@emc.com.tw>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 14:34:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 14:34:46,
	Serialize complete at 2011-08-18 14:34:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 09:57 AM, JJ Ding wrote:
>   	if (elantech_set_absolute_mode(psmouse)) {
>   		pr_err("failed to put touchpad into absolute mode.\n");
>   		goto init_fail;
Hi JJ,
--
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index e13a719..675c236 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1069,7 +1069,7 @@ int elantech_init(struct psmouse *psmouse)

         return 0;

- init_fail:
+init_fail:
         kfree(etd);
         return -1;
  }
--

also has space before *init_fail*, you may do this in your next version.

Thanks
-Wanlong Gao
