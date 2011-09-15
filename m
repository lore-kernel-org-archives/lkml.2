Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1IOHYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:24:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47709 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754737Ab1IOHYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:24:41 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1/D5/ESwnrDN9QVVwWD8hOJcj0u7ppJI3hY+BeJZe
	S98yxEZLxCyoNI
Message-ID: <4E71A821.6010106@gmx.de>
Date: Thu, 15 Sep 2011 09:24:17 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Lin Ming <mlin@ss.pku.edu.cn>
CC: fa.linux.kernel@googlegroups.com, slawomir.czarko@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
References: <fa.FZDTDqnxL4JfQvyaCQTn405rzwM@ifi.uio.no> <ee48c89a-1e72-4b35-b9fc-99f4b8ade483@glegroupsg2000goo.googlegroups.com> <CAF1ivSY7rHuA_SGpnPkQ2hLwwOTEtDFTn=e_vx1=C_kW3aDjRA@mail.gmail.com> <CAF1ivSZzUiwn+pqLCtOiCEDvjwpLXrXBkCL5OnsAW1vLdMY32w@mail.gmail.com>
In-Reply-To: <CAF1ivSZzUiwn+pqLCtOiCEDvjwpLXrXBkCL5OnsAW1vLdMY32w@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.09.2011 08:48, schrieb Lin Ming:
>> Hi, Thomas
>>
>> Do you still see this problem on latest kernel(2.6.31-rc6)?
>> I try to run firefox (>50 open Tabs), but can't reproduce
>> this on 2.6.31-rc6 kernel.
> 
> Sorry, I mean 3.1-rc6

For me the problem was gone with Mel Gorman's patchset "Fix
compaction stalls due to accounting errors in isolated page
accounting". I applied them to 2.6.38.8 and never had any
problems.

They went into 2.6.39.4 and 3.0 and both machines that were
affected are now running fine. (One of the machine throws
MCE-Errors every now and than, but this is another problem.)

Thomas
