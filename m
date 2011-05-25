Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1EYUh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:37:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab1EYUhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:37:25 -0400
Message-ID: <4DDD68C3.7000004@suse.cz>
Date: Wed, 25 May 2011 22:38:27 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Armin Schindler <armin@melware.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 12/34] isdn/diva: Drop __TIME__ usage
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-13-git-send-email-mmarek@suse.cz> <alpine.DEB.2.00.1104051709040.7262@justus.melware.de>
In-Reply-To: <alpine.DEB.2.00.1104051709040.7262@justus.melware.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 5.4.2011 17:10, Armin Schindler napsal(a):
> On Tue, 5 Apr 2011, Michal Marek wrote:
>> The kernel already prints its build timestamp during boot, no need to
>> repeat it in random drivers and produce different object files each
>> time.
> 
> The module can be build separately from the kernel, therefore it can have
> an own build timestamp.

So the module timestamp and kernel timestamp vary by a couple of
minutes. But is it really a problem? I don't think so. So is there an
objection against applying this patch?

thanks,
Michal
