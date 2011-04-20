Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1DTUBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:01:40 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:46856 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1DTUBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:01:39 -0400
Date: Wed, 20 Apr 2011 21:52:39 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ciprian Docan <docan@eden.rutgers.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael, J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
        nic_swsd@realtek.com
Subject: Re: Suspend/resume - slow resume
Message-ID: <20110420195239.GA18897@electric-eye.fr.zoreil.com>
References: <Pine.SOC.4.64.1104151122330.1320@er3.rutgers.edu> <BANLkTi=Gq5thZk2f1nWTz3dDA5Non8ANZg@mail.gmail.com> <20110417101731.GA17986@electric-eye.fr.zoreil.com> <BANLkTi=tPc6NmUuTYqbVZduNRNbE=-c34Q@mail.gmail.com> <20110418180813.GA18469@electric-eye.fr.zoreil.com> <BANLkTim_1OgqjCeD1a4Ay2fWJSmPHa_XTQ@mail.gmail.com> <Pine.SOC.4.64.1104181519490.1320@er3.rutgers.edu> <BANLkTi=dke10HougmiQn9hSF15nK0B8mdA@mail.gmail.com> <20110420181602.GA18740@electric-eye.fr.zoreil.com> <Pine.SOC.4.64.1104201445420.1320@er3.rutgers.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.1104201445420.1320@er3.rutgers.edu>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ciprian Docan <docan@eden.rutgers.edu> :
[...]
> Here is what I did to test it: I compiled the patched module,
> unloaded the previous module, loaded the new one, and then suspend &
> resume. Output of dmesg attached. Please let me know if you need any
> other information.

Thanks.

You can remove the firmware and try the same test.

Then you try again with a non-modular r8169 driver, with and without
firmware.

You should see a few extra messages but suffer no extra delay during
resume.

-- 
Ueimor
