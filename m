Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0ICJNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:13:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab0ICJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:13:54 -0400
Message-ID: <4C80BC3A.7010406@corscience.de>
Date: Fri, 03 Sep 2010 11:13:30 +0200
From: Bernhard Walle <walle@corscience.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Arnaud Patard <apatard@mandriva.com>
CC: Christoph Hellwig <hch@lst.de>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, ddaney@caviumnetworks.com,
        akpm@linux-foundation.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: N32: Fix getdents64 syscall for n32
References: <1283501734-6532-1-git-send-email-walle@corscience.de>	<20100903084213.GA32339@lst.de> <m3pqwvb438.fsf@anduin.mandriva.com>
In-Reply-To: <m3pqwvb438.fsf@anduin.mandriva.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:R8n2dqZbSo1xc86ONWX6R7PJJuLEVGlBZwPViS+/OGh
 523htMkIdbHbIkOqda0TIPPN4JyDI7383qOLwUNK342kBNRpba
 RlUPBnCwU53qneUJtvpdL95qE1sZPDzHzHOzY1T/UQOsCqb0VX
 2oVyEQidoZ1JfsIgMa1TUkVIy3E89nZKOwwcxBggcZMXo/cqiz
 LXrzoU8SA2i88F6SXPI1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.09.2010 10:53, schrieb Arnaud Patard:
>
> I guess the explanation is the one below :
>
> $ ./scripts/get_maintainer.pl -f arch/mips/kernel/scall64-n32.S
> Ralf Baechle<ralf@linux-mips.org>
> David Daney<ddaney@caviumnetworks.com>
> Andrew Morton<akpm@linux-foundation.org>
> "Eric W. Biederman"<ebiederm@xmission.com>
> Christoph Hellwig<hch@lst.de>
> linux-mips@linux-mips.org
> linux-kernel@vger.kernel.org

Yes, I just used that script and trusted the results. Sorry for that.


Regards,
Bernhard
