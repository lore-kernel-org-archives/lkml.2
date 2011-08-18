Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1HRDr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 23:47:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61929 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755048Ab1HRDrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 23:47:24 -0400
Message-ID: <4E4C8B63.7030108@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 11:47:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: gaowanlong@cn.fujitsu.com
CC: JJ Ding <jj_ding@emc.com.tw>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw> <4E4C8758.4020205@cn.fujitsu.com>
In-Reply-To: <4E4C8758.4020205@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 11:46:07,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 11:46:10,
	Serialize complete at 2011-08-18 11:46:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +
>> +    case 3:
>> +        if (elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>> +            elantech_ps2_command(psmouse, NULL, ETP_REGISTER_READWRITE) ||
>> +            elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>> +            elantech_ps2_command(psmouse, NULL, reg) ||
>> +            elantech_ps2_command(psmouse, param, PSMOUSE_CMD_GETINFO)) {
>> +            rc = -1;
>> +        }
> Prefer to remove these big brace ?
> also with "case 1, case 2 "?

Just wondering What's wrong with this piece of code and what do you
sugguest to improve it?
