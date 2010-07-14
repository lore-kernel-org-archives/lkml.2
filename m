Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0GNJ1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 05:27:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:40881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713Ab0GNJ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 05:27:32 -0400
Message-ID: <4C3D82BD.2090609@kernel.org>
Date: Wed, 14 Jul 2010 11:26:21 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 11/12] libata: use IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-12-git-send-email-tj@kernel.org> <4C23F6C1.7070603@garzik.org> <4C245E50.7090701@kernel.org> <4C2577F2.4030005@garzik.org> <4C25BAD2.4070705@kernel.org> <4C25C551.8000404@garzik.org> <4C25CC18.2070507@kernel.org> <4C2DFAB0.3020703@kernel.org> <4C384620.8040808@kernel.org> <4C3D6E0F.20605@garzik.org>
In-Reply-To: <4C3D6E0F.20605@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Jul 2010 09:26:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 09:58 AM, Jeff Garzik wrote:
> Give me another day or two.  I'm working up an alternate patch for
> demonstration (still use the irq-expecting api, but differently).

Sure thing.

Thanks.

-- 
tejun
