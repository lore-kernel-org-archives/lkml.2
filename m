Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab2LEVvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:51:07 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:58008 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab2LEVvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:51:05 -0500
MIME-Version: 1.0
In-Reply-To: <20121205192141.GQ14363@n2100.arm.linux.org.uk>
References: <000201cdd283$baf50160$30df0420$%han@samsung.com>
 <20121205093027.GK14363@n2100.arm.linux.org.uk> <CAHod+Gdb_LEnhx5cz9j=q9PyS4L=Yjxs303dHon9i-tgjJRtDA@mail.gmail.com>
 <20121205192141.GQ14363@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 5 Dec 2012 21:50:42 +0000
X-Google-Sender-Auth: T67CQGenmcMGqtNGOhh4tAIPoSA
Message-ID: <CACxGe6sz_5epOLW47-nbXpBrjc4ZAVaFL3Ge5jt8H9HEbnzpcw@mail.gmail.com>
Subject: Re: [PATCH v4] backlight: corgi_lcd: Use gpio_set_value_cansleep() to
 avoid WARN_ON
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?UTF-8?B?TWFya28gS2F0acSH?= <dromede@gmail.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marek.vasut@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 7:21 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> As I say above, IMHO it would've been much better to rename these functions
> to be the other way around but David was always very dismissive of any
> comments I had against any code he'd written.

FWIW, I'll gladly take a patch to rename them now if someone does the legwork.

g.
