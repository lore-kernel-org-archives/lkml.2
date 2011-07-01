Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1GAIy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 04:54:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53547 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab1GAIyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 04:54:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110701061943.GA17184@marc.osknowledge.org>
References: <20110630213728.GA30291@marc.osknowledge.org>
	<BANLkTimk_yCCy+4hL6949nxPs5Qo4y1Qow@mail.gmail.com>
	<20110701061943.GA17184@marc.osknowledge.org>
Date: Fri, 1 Jul 2011 16:54:54 +0800
Message-ID: <BANLkTimAyhUxcLCyXLKoWuv7wPhUiMh--A@mail.gmail.com>
Subject: Re: CONFIG_ACPI_PROC_EVENT disabled -> userspace not working (Was:
 Re: CONFIG_ACPI_PROCFS_POWER to be removed in 2.6.39)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Marc Koschewski <marc@osknowledge.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc linux-acpi@vger.kernel.org...)

On Fri, Jul 1, 2011 at 2:19 PM, Marc Koschewski <marc@osknowledge.org> wrote:
> * Américo Wang <xiyou.wangcong@gmail.com> [2011-07-01 08:55:23 +0800]:
>
> I just disabled the 3 'deprecated' within ACPI and ACPI userspace is not working
> any longer. I'm using Gentoo so I doubt my userspace is too old. acpid doesn't
> somehow listen to events when CONFIG_ACPI_PROC_EVENT is not set:
>
> "Say Y here to retain the old behaviour.  Say N if your
> user-space is newer than kernel 2.6.23 (September 2007)."
>
>> On Fri, Jul 1, 2011 at 5:37 AM, Marc Koschewski <marc@osknowledge.org> wrote:
>> > Hey guys,
>> >
>> > CONFIG_ACPI_PROCFS_POWER is still there. Missed it or did you want it
>> > to reside?
>>
>> There was a patch to remove it,
>>
>> https://patchwork.kernel.org/patch/654021/
>>
>> Don't know why it is not merged.
>>
>>
>
> --
> Marc Koschewski
>
