Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab1HREQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 00:16:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56936 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab1HREQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 00:16:05 -0400
Message-ID: <4E4C91C4.2080408@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 12:15:00 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
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
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw> <4E4C8758.4020205@cn.fujitsu.com> <4E4C8B63.7030108@cn.fujitsu.com>
In-Reply-To: <4E4C8B63.7030108@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 12:14:48,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 12:14:52,
	Serialize complete at 2011-08-18 12:14:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 11:47 AM, Li Zefan wrote:
>>> +
>>> +    case 3:
>>> +        if (elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>>> +            elantech_ps2_command(psmouse, NULL, ETP_REGISTER_READWRITE) ||
>>> +            elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>>> +            elantech_ps2_command(psmouse, NULL, reg) ||
>>> +            elantech_ps2_command(psmouse, param, PSMOUSE_CMD_GETINFO)) {
>>> +            rc = -1;
>>> +        }
>> Prefer to remove these big brace ?
>> also with "case 1, case 2 "?
>
> Just wondering What's wrong with this piece of code and what do you
> sugguest to improve it?

I think no need to add a '{}' with the *if* ?
and remove the '{}' in whole elantech_read_reg() and 
elantech_write_reg(), right?

-Wanlong Gao

