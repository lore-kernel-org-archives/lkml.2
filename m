Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0IBRNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:13:35 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:57472 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0IBRNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:13:34 -0400
Message-ID: <4C7FDB3B.9030806@tilera.com>
Date: Thu, 2 Sep 2010 13:13:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 22/24] ptrace: cleanup arch_ptrace() on tile
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com> <1283442391-23612-23-git-send-email-namhyung@gmail.com> <4C7FD244.8050502@tilera.com> <AANLkTi=kvktxn_03LOAre0ZiRkswwf-O1hg07ZsShEeN@mail.gmail.com>
In-Reply-To: <AANLkTi=kvktxn_03LOAre0ZiRkswwf-O1hg07ZsShEeN@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 9/2/2010 12:55 PM, Namhyung Kim wrote:
> On Fri, Sep 3, 2010 at 01:35, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> This omits the change to the actual function definition, which was present
>> in the previous version of this patch.
> That change was moved/combined into previous patch in this series.
> Please check out 03/24 in this patchset also.

Sure, that looks fine.  And sizeof(unsigned long) is OK; I don't have a
real axe to grind there.

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

