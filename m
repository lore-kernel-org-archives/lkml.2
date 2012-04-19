Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab2DSLcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:32:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab2DSLcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:32:15 -0400
Message-ID: <4F8FF7AC.1060309@redhat.com>
Date: Thu, 19 Apr 2012 14:31:56 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: zhangyanfei@cn.fujitsu.com, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, joerg.roedel@amd.com, dzickus@redhat.com,
        paul.gortmaker@windriver.com, gregkh@suse.de, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH 0/4] Export offsets of VMCS fields as note information
 for kdump
References: <4F8EABF7.805@redhat.com> <20120419.193640.59653378.d.hatayama@jp.fujitsu.com> <4F8FEC22.400@redhat.com> <20120419.202707.276752866.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20120419.202707.276752866.d.hatayama@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 02:27 PM, HATAYAMA Daisuke wrote:
> >> The reason why we want to retrieve guest machine's memory image as
> >> crash dump is that then we can debug guest machine's status using
> >> symbolic debugger such as gdb and crash utility.
> >>
> >> This is very useful. Please consider the situation where engineers are
> >> forced to look into guest machine's memory image through qemu-kvm's
> >> process core dump using gdb without any symbolic information. It's
> >> very inefficient.
> > 
> > I still don't follow.  If qemu crashed, the values in guest registers
> > are irrelevant.  In what way can the help debug the qemu crash?
> > 
>
> It would be not helpful for the qemu crash case you are concerned
> about. We want to use the guest state data to look into guest
> machine's image in the crasshed qemu.

Why?

-- 
error compiling committee.c: too many arguments to function

