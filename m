Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1CKMSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:18:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49960 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1CKMSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:18:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=YkXanCUyl72oQLdaNw2ozNUeHjuaZVankB+XrGa895Vx0tJ4bF2W2+bDH7DgE0soZy
         FyriGtrrwr78wSSvBbDnuInnaYpdSpy9iX15J4dGJ2NjbLHGMYEKqvSepIBsZ1iGPjMs
         YPXNqtXsm+KdOjOGF4xjqTkwy2xIVR/ZEgMiw=
Message-ID: <4D7A1322.4050706@suse.cz>
Date: Fri, 11 Mar 2011 13:18:42 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm <linux-pm@lists.linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: Why is max_cstate=1 still needed?
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

there are still reports against the latest kernels, that people need to
pass processor/intel_idle.max_cstate=1 to successfully boot the kernel.
The symptoms are always the same, until the parameter is specified OR
until the user presses a key, the system won't boot up.

This started to appear between 2.6.31 and 2.6.34 (possibly a 2.6.33
regression) and continues to be reported against the latest stable
2.6.37.3. For example:
https://bugzilla.kernel.org/show_bug.cgi?id=15289
https://bugzilla.novell.com/show_bug.cgi?id=579932
https://bugzilla.novell.com/show_bug.cgi?id=673589
https://bugzilla.novell.com/show_bug.cgi?id=675161

I see that there were some fixes in .38-rc in this bug report (they look
unrelated):
https://bugzilla.kernel.org/show_bug.cgi?id=29992

Should they give .38-rc a try?

Any help would be appreciated.

thanks,
-- 
js
suse labs
