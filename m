Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1HQOEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:04:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab1HQOEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:04:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 2/3] cputime: clean up cputime_to_usecs and usecs_to_cputime macros
Date: Wed, 17 Aug 2011 16:02:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, cpufreq@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
References: <20110802170249.GA23698@tiehlicka.suse.cz> <cover.1312544541.git.mhocko@suse.cz> <c6c176ace7eca5fffe568865193a1061d181c77c.1312544541.git.mhocko@suse.cz>
In-Reply-To: <c6c176ace7eca5fffe568865193a1061d181c77c.1312544541.git.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108171602.49444.arnd@arndb.de>
X-Provags-ID: V02:K0:gFItRn673cSwMILefSqaGown4gZrQO+Qp4MczvtmxKS
 AVLaZibnNA5DgUz/rL3Fz7G1IFspGi0jdYE8LAirCFx1pT1dlh
 x0XOqDGLfDz2CuDV4kvIHsm3LIq+CIbrbcsCC0I7i7w3eQce8l
 0POe/83hTDqDlwK19DKeqojwX4gmIIw/wbhT3JB7chULHe4/oD
 4VvWGxof7FUWmf1euI7hw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 August 2011, Michal Hocko wrote:
> get rid of semicolon so that those expressions can be used also
> somewhere else than just in an assignment.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Arnd Bergmann <arnd@arndb.de>
