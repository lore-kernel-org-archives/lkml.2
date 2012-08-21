Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab2HUNIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:08:43 -0400
Received: from natasha.panasas.com ([67.152.220.90]:37315 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2HUNIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:08:40 -0400
Message-ID: <5033883C.7050200@panasas.com>
Date: Tue, 21 Aug 2012 16:08:12 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
References: <20120820183225.GB4911@fieldses.org> <20120820190606.GE27443@moon> <20120820193204.GD5779@fieldses.org> <50335261.5090504@parallels.com> <87wr0sle4v.fsf@skywalker.in.ibm.com> <503367CB.9080609@parallels.com> <20120821105424.GA7670@moon> <50336C51.60501@parallels.com> <20120821121155.GC9483@fieldses.org> <50337D87.90607@parallels.com> <20120821122908.GE9483@fieldses.org> <50338458.7090602@panasas.com> <5033864A.5040809@parallels.com>
In-Reply-To: <5033864A.5040809@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 03:59 PM, Pavel Emelyanov wrote:

> On 08/21/2012 04:51 PM, Boaz Harrosh wrote:
>> On 08/21/2012 03:29 PM, J. Bruce Fields wrote:
>> <>
> 
> Strictly speaking -- no we don't. Migration should to work across kernel
> versions (from older to newer). Why kernel version matters in this case?


I was thinking of an FS that used to not implement export_fh but starts
to in the new version. Or some other such change in fhandles. But it's
such a far fetch I agree.

Boaz
