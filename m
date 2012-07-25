Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab2GYSy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:54:56 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50343 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2GYSyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:54:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
References: <1343176370-5856-1-git-send-email-ccross@android.com>
	<CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
Date: Wed, 25 Jul 2012 11:54:54 -0700
X-Google-Sender-Auth: 2gwI-JU5RqCARv-dyc5c9F2KN-g
Message-ID: <CAMbhsRS-TiBE92nL0Cwc-ssZAMaHE2ET0UE8h7RU3VG6F6+Xtw@mail.gmail.com>
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
From: Colin Cross <ccross@android.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 11:11 PM, Bryan Wu <bryan.wu@canonical.com> wrote:
> On Wed, Jul 25, 2012 at 8:32 AM, Colin Cross <ccross@android.com> wrote:
>> Some triggers create sysfs files when they are enabled.  Send a uevent
>> "change" notification whenever the trigger is changed to allow userspace
>> processes such as udev to modify permissions on the new files.
>>
>
> This looks like an workaround only for led trigger, can we fix this in
> sysfs level?

See the previous discussion here: https://lkml.org/lkml/2012/7/20/458
