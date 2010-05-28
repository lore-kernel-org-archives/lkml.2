Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab0E1UPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:15:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44360 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab0E1UPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:15:00 -0400
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for
 select intel processors
From: Chase Douglas <chase.douglas@canonical.com>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
In-Reply-To: <1275076262.12653.7.camel@cndougla-ubuntu>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
	 <1275013933.2312.7.camel@cndougla-ubuntu>
	 <alpine.LFD.2.00.1005272359510.24823@localhost.localdomain>
	 <1275059380.5612.60.camel@cndougla-ubuntu>
	 <alpine.LFD.2.00.1005281343060.4045@localhost.localdomain>
	 <1275076262.12653.7.camel@cndougla-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 16:14:52 -0400
Message-ID: <1275077692.12653.13.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 15:51 -0400, Chase Douglas wrote:
> On Fri, 2010-05-28 at 13:43 -0400, Len Brown wrote:
> > Atom C4 works in the current driver in the git tree -- test it now!
> 
> Sadly, it seems this isn't helping much. My netbook still idles at ~60
> centigrade on and off power. I will verify that before this change I was
> able to idle cooler when off power just to be sure.

Well, now I seem unable to reproduce the lower temperatures at all... I
tried the same kernel without your patches and mostly got the same
temperatures. I tried the Ubuntu 10.04 LTS 2.6.32 based kernel and it
was two or three centigrade cooler, but not the tens of centigrade
cooler I remembered. I also can't see a big change anymore when power is
plugged in or not. Maybe it was all a matter of usage in different
environments making me think it was related to being plugged into power
or not. Oy vey...

-- Chase

