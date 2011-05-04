Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1EDMuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:50:32 -0400
Received: from mailout.rz.uni-frankfurt.de ([141.2.22.233]:39870 "EHLO
	mailout.rz.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753134Ab1EDMub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:50:31 -0400
X-Greylist: delayed 1823 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 May 2011 08:50:31 EDT
Message-ID: <4DC14474.9040001@gmx.de>
Date: Wed, 04 May 2011 14:20:04 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
References: <4DAF6C0B.3070009@gmx.de> <20110427134613.GI32590@random.random>
In-Reply-To: <20110427134613.GI32590@random.random>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different machine (kernel 2.6.38.2) 4x SYSRQ+l

   http://pastebin.com/raw.php?i=B2XeVyz6
    (URL should be valid for one month)

Since this is a DualCore machine, it is still
quite usable. I'll try to keep it running, in
case you need more details.

BTW: I haven't seen the problem with 2.6.38.4
so far. May have been fixed in the meantime?

Thomas
