Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab2CEPoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:44:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab2CEPoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:44:15 -0500
Date: Mon, 5 Mar 2012 10:44:12 -0500
From: Dave Jones <davej@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: WARNING: Adjusting tsc more then 11%
Message-ID: <20120305154411.GA29668@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	John Stultz <john.stultz@linaro.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,
We've had a number of reports the last few weeks triggering
this warning that you added back in October.

https://bugzilla.redhat.com/show_bug.cgi?id=798600
https://bugzilla.redhat.com/show_bug.cgi?id=799215
https://bugzilla.redhat.com/show_bug.cgi?id=799745
https://bugzilla.redhat.com/show_bug.cgi?id=799872

any idea what could have changed to start tripping that up ?

The reports seem to have started around 3.3-rc4.

	Dave

