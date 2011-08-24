Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1HXVs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:48:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35531 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab1HXVs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:48:26 -0400
Message-ID: <4E5571A6.6050705@suse.cz>
Date: Wed, 24 Aug 2011 23:48:22 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>, alan@linux.intel.com,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: patch "TTY: remove tty_locked" added to tty tree
References: <13141210141189@kroah.org> <201108241320.47635.arnd@arndb.de> <4E54E4D9.6070802@suse.cz> <201108241635.13502.arnd@arndb.de> <4E556CB7.2010102@suse.cz> <20110824214201.GB30829@suse.de>
In-Reply-To: <20110824214201.GB30829@suse.de>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 11:42 PM, Greg KH wrote:
> So, is your original patch you sent in this thread still needed?

If you mean "TTY: remove tty_locked", then yes, it's fine to see
tty_locked go. It looks like we won't need it to fix the stalls in the
end. If you mean TTY-fix-stalls-on-BTM-when-waiting-until-sent, that one
will be superseded by a new one.

thanks,
-- 
js
suse labs
