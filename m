Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab1H1QF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 12:05:29 -0400
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:37997 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1H1QFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 12:05:25 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Aug 2011 12:05:25 EDT
Message-ID: <4E5A651A.6020005@example.com>
Date: Sun, 28 Aug 2011 17:56:10 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Some regression since rc3
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 7285416822671241496
X-Ovh-Remote: 178.36.57.197 (178-36-57-197.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeftddrtddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenuc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I almost cannot work. I tried todays rc3-git3 and I see that icedove 
mailer keeps growing almost instantly to 100% cpu. I tried rc3-git3 but 
to no avail. I am booted on plain rc3 now and I can work, but not 
perfect still as before.

Regards,

Piotr Hosowicz

-- 
"Polski system finansowy w okresie transformacji przejdzie do anna³ów
historii nonsensu, a logika polskich libera³ów jest logika z pogranicza
surrealizmu". - Milton Friedman, laureat nagrody Nobla nazywany
papie¿em wolnego rynku
NP: Ugly Kid Joe - Sandwich
NB: 3.1.0-rc3
