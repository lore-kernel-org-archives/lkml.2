Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab0E1TvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:51:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60727 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab0E1TvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:51:11 -0400
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for
 select intel processors
From: Chase Douglas <chase.douglas@canonical.com>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
In-Reply-To: <alpine.LFD.2.00.1005281343060.4045@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
	 <1275013933.2312.7.camel@cndougla-ubuntu>
	 <alpine.LFD.2.00.1005272359510.24823@localhost.localdomain>
	 <1275059380.5612.60.camel@cndougla-ubuntu>
	 <alpine.LFD.2.00.1005281343060.4045@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 15:51:01 -0400
Message-ID: <1275076262.12653.7.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 13:43 -0400, Len Brown wrote:
> Atom C4 works in the current driver in the git tree -- test it now!

Sadly, it seems this isn't helping much. My netbook still idles at ~60
centigrade on and off power. I will verify that before this change I was
able to idle cooler when off power just to be sure.

I do see the C4 state both on and off power, so that's nice at least.
I'm just perplexed why my netbook runs so hot when idle. I even killed X
to see if it was really the gpu that was heating everything inside up,
but it didn't change anything.

-- Chase

