Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab3AISzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:55:32 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:40170 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab3AISza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:55:30 -0500
MIME-Version: 1.0
In-Reply-To: <1357742188-8941-1-git-send-email-vgupta@synopsys.com>
References: <50ED7B4B.7080603@synopsys.com>
	<1357742188-8941-1-git-send-email-vgupta@synopsys.com>
Date: Wed, 9 Jan 2013 10:55:27 -0800
Message-ID: <CA+8MBbJNrJYeZoGXt37ki_YCpb7kqiE1toFoBBHrtmnY8a75VA@mail.gmail.com>
Subject: Re: [PATCH v2] sysctl: Enable IA64 "ignore-unaligned-usertrap" to be
 used cross-arch
From: Tony Luck <tony.luck@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. Queued for 3.9 merge window.  It should show up in linux-next in
the next day or two.  We'll see if anyone complains about the name
SYSCTL_ARCH_UNALIGN_NO_WARN (every time I touch the Kconfig
bits it seems that there is some other, better way that we do this now).

-Tony
