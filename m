Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1GDDzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 23:55:45 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61417 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1GDDzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 23:55:44 -0400
Date: Mon, 4 Jul 2011 11:55:23 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        bhutchings@solarflare.com, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net
Subject: Re: [PATCH 0/5 v2] PCI: fix cardbus and sriov regressions
Message-ID: <20110704035519.GA2162@gmail.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, yinghai@kernel.org,
	bhutchings@solarflare.com, socketcan@hartkopp.net,
	bhelgaas@google.com, linux@dominikbrodowski.net
References: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
 <CA+55aFwo-48yKu+raRF3B9n1mqd1qV35eDq56Yi+erPygkuTvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <CA+55aFwo-48yKu+raRF3B9n1mqd1qV35eDq56Yi+erPygkuTvA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 02:30:00PM -0700, Linus Torvalds wrote:
> And some of the cleanup stuff I could merge for 3.0 just to make things easier.
Hi linus,
	IMO, codingstyle is so important for us. It turns our codes readable and 
easy. What you said in the Documentation/CodingStyle file is always useful. We
should allow the rules in it, which is helpful for maintainers to manage their branches. 
I will devote myself to fixing some cleanup for us. I think that would be so exciting for me.

Cheers

Thanks
Harry Wei

