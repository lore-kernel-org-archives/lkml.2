Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1ECNh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 09:37:28 -0400
Received: from muse.oxfordinspire.co.uk ([93.93.128.48]:60046 "EHLO
	muse.oxfordinspire.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1ECNh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 09:37:26 -0400
X-Greylist: delayed 1685 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 May 2011 09:37:26 EDT
Message-ID: <4DBFFE64.6000306@exotica.org.uk>
Date: Tue, 03 May 2011 14:08:52 +0100
From: Jools Wills <buzz@exotica.org.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Walter Goldens <goldenstranger@yahoo.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Roland Dreier <roland@kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38: rt2800usb: driver is crashing the kernel
References: <484421.61252.qm@web161619.mail.bf1.yahoo.com>
In-Reply-To: <484421.61252.qm@web161619.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -2.9 (--)
X-Spam-Report: Spam detection software, running on the system "muse.oxfordinspire.co.uk", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  in case it is useful: I am currently using the vendor driver
    on a device I have (O2 Joggler). The rt2800usb driver didn't work well and
    the staging rt2870sta driver didn't seem to work with wireless N and users
    reported to me that it drops the connection and is unreliable. The vendor
    driver does seem to work best. [...] 
 Content analysis details:   (-2.9 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in case it is useful:

I am currently using the vendor driver on a device I have (O2 Joggler).
The rt2800usb driver didn't work well and the staging rt2870sta driver
didn't seem to work with wireless N and users reported to me that it
drops the connection and is unreliable. The vendor driver does seem to
work best.

I made a debian package (using dkms) of the vendor driver on my joggler
ppa. tested working wiht 2.6.37/2.6.38

https://launchpad.net/~jools/+archive/joggler

note it doesn't automatically install the newer firmware so that will
need to be done manually.

Best Regards

Jools
