Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2KTDLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:11:17 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37398 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2KTDLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:11:16 -0500
MIME-Version: 1.0
In-Reply-To: <1353112043-11800-1-git-send-email-wfp5p@virginia.edu>
References: <1353112043-11800-1-git-send-email-wfp5p@virginia.edu>
Date: Tue, 20 Nov 2012 08:41:15 +0530
X-Google-Sender-Auth: xMpLu6ugqnImOKCtk9tSqY42xsI
Message-ID: <CAOh2x=ndu+T2mgd_GxOwMo0hgGyHqOSm2m4MKWkCkMHxFRfUhA@mail.gmail.com>
Subject: Re: [PATCH 000/493] remove CONFIG_HOTPLUG as an option
From: viresh kumar <viresh.kumar@linaro.org>
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 5:49 AM, Bill Pemberton <wfp5p@virginia.edu> wrote:
> CONFIG_HOTPLUG is no longer an optional setting.  In order to remove
> it as on option code paths that check CONFIG_HOTPLUG will removed
> along with the attributes __devexit_p, __devexit, __devinitconst, and
> __devinitdata.
>
> I'll save the list from the mailbomb of this huge patchset.  The
> patches themselves are going to Greg KH for the driver core tree.
>

Fed up for replying on all mails :(
Acked-by: Viresh Kumar <viresh.kumar@linaro.org> for all mails where i
am in cc :)

--
viresh
