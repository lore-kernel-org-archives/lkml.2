Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0L2QXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 11:23:11 -0500
Received: from 30.mail-out.ovh.net ([213.186.62.213]:58765 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753357Ab0L2QXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 11:23:06 -0500
Message-ID: <4D1B6066.9000701@example.com>
Date: Wed, 29 Dec 2010 17:23:02 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: GIT question - am I doing it correctly?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6946520951010128152
X-Ovh-Remote: 83.24.111.204 (dod204.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Everytime I git pull tyhe Linus' sources but before I build I apply 
Peter Zijlstra's fixes, Takashi Iwai's sources and Dave Miller's 
sources. The sequence is:

# the Linus' sources
git pull

# external sources
git remote add some_name git://some_URL.git

# update
git remote update

Then configure and I build. I noticed that especially Peter's git-update 
very quickly, not as long as they did before.

Is my procedure correct? I am new to GIT.

Regards,

Piotr Hosowicz

-- 
W trosce o najm³odsze pokolenie, nasi ustawodawcy winni znowelizowaæ
ustawê o wychowaniu w trze¼wo¶ci i przeciwdzia³aniu alkoholizmowi tak,
¿eby zakazaæ wprowadzania na rynek gier planszowych, których celem
jest jak najszybsze dotarcie do mety.
NP: Peter Green Splinter Group - Turn Your Love Away
NB: 2.6.37-rc8
