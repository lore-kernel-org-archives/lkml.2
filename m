Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2EDLEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 07:04:55 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45675 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834Ab2EDLEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 07:04:53 -0400
Message-ID: <4FA3B7BA.5090400@mvista.com>
Date: Fri, 04 May 2012 15:04:26 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20120503182735.GA24318@havoc.gtf.org> <4FA2CF02.7090708@mvista.com> <4FA2D09F.2000006@garzik.org>
In-Reply-To: <4FA2D09F.2000006@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-05-2012 22:38, Jeff Garzik wrote:

>>> Please pull 5f098a3ea72e73ad3733c3280fd5ee04816dc999 from
>>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>>> tag/upstream-linus

>>> to receive the following updates:

>>> Documentation/devicetree/bindings/ata/ahci-platform.txt | 16
>>> +++++++++++++++
>>> Documentation/devicetree/bindings/ata/calxeda-sata.txt | 17
>>> ----------------

>> Originally it was a file rename -- did that get preserved?

> You caught me: I manually generated the diffstat :)

    And I didn't read the patch attentiuvely enough...

> It is correct in git, as a file rename.

    Sorry for the false alarm. :-)

> Jeff

MBR, Sergei
