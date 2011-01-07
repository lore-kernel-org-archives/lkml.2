Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1AGPNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:13:07 -0500
Received: from 29.mail-out.ovh.net ([87.98.216.213]:33538 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752548Ab1AGPNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:13:05 -0500
Message-ID: <4D272D7C.4070900@example.com>
Date: Fri, 07 Jan 2011 16:13:00 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: GIT again
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3277776105568694552
X-Ovh-Remote: 83.24.110.28 (doc28.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.500004/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for bothering again. I think I fimanaged to build the kernel as I 
wanted to. Lets simplify the problem. There is Linus tree and a separate 
tree, which was announed here as:

git://git.kernel.org/some.git for-linus

The objective is to build the kernel with Linus sources with some.git 
changes incorporatwed in it. I think I managed to achieve the objective 
doing:

# let me remind myself ;-)
git clone <Linus URL here>
git remote add some git://git.kernel.org/some.git
git pull some for-linus

I've done it this way and I am convinced I've achieved the objective. 
But not sure. For sure the last command modified the source, what is 
what I wanted, I had to finally correct ot by hand and do git commit -a.

Am I right?

Regards,

Piotr Hosowicz

-- 
- Poszed³em wczoraj z ¿on± do ZOO
- I jak?
- Nie wziêli...
NP: Peter Green Splinter Group - Turn Your Love Away
NB: 2.6.37-20110107-1437-pztidm+
