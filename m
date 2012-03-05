Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2CEWKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:10:53 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38438 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab2CEWKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:10:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.52.33.239 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120305220651.GB16312@ubuntu-macmini>
References: <1329424465-1211-1-git-send-email-seth.forshee@canonical.com>
	<1329921457-26887-1-git-send-email-seth.forshee@canonical.com>
	<20120305220651.GB16312@ubuntu-macmini>
Date: Mon, 5 Mar 2012 17:10:50 -0500
Message-ID: <CA+5PVA5nRvtDPXgen5=10=Yt2YdQAUo-K+OK8MXENiQ7wEQCYg@mail.gmail.com>
Subject: Re: [PATCH v2] platform/x86: Add driver for Apple gmux device
From: Josh Boyer <jwboyer@gmail.com>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 5:06 PM, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Wed, Feb 22, 2012 at 08:37:37AM -0600, Seth Forshee wrote:
>> Apple laptops with hybrid graphics have a device named gmux that
>> controls the muxing of the LVDS panel between the GPUs as well as screen
>> brightness. This driver adds support for the gmux device. Only backlight
>> control is supported initially.
>>
>> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
>
> Ping. Is there anything that would prevent getting this into 3.4?

I sent a list of patches that seemed ready for 3.4 to Matthew last week.  This
was on the list and he seemed to agree.  I would guess he just either needs
a minion, a clone, or a time machine.  Or maybe all three.

josh
