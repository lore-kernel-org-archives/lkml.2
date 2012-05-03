Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab2ECSi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:38:27 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58089 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2ECSi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:38:26 -0400
Message-ID: <4FA2D09F.2000006@garzik.org>
Date: Thu, 03 May 2012 14:38:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20120503182735.GA24318@havoc.gtf.org> <4FA2CF02.7090708@mvista.com>
In-Reply-To: <4FA2CF02.7090708@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 02:31 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 05/03/2012 10:27 PM, Jeff Garzik wrote:
>
>> Please pull 5f098a3ea72e73ad3733c3280fd5ee04816dc999 from
>> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>> tag/upstream-linus
>
>
>> to receive the following updates:
>
>> Documentation/devicetree/bindings/ata/ahci-platform.txt | 16
>> +++++++++++++++
>> Documentation/devicetree/bindings/ata/calxeda-sata.txt | 17
>> ----------------
>
> Originally it was a file rename -- did that get preserved?

You caught me:  I manually generated the diffstat :)

It is correct in git, as a file rename.

	Jeff




