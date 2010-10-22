Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759663Ab0JVTGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:06:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53683 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759495Ab0JVTGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:06:42 -0400
Message-ID: <4CC1E0B9.5060403@zytor.com>
Date: Fri, 22 Oct 2010 12:06:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP
 on VM_IO vmas
References: <4CC0C14E.5080205@goop.org> <4CC0C318.90401@zytor.com> <4CC0CA07.3000306@goop.org> <4CC0DEB8.1060309@zytor.com> <20101022150826.GA23325@dumpdata.com> <4CC1BF58.9020001@zytor.com> <20101022180231.GA26365@dumpdata.com>
In-Reply-To: <20101022180231.GA26365@dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 11:02 AM, Konrad Rzeszutek Wilk wrote:
> 
> I hope my explanation cleared the confusion.
> 
>> me and I'm not sure it is the right solution.

OK, now I'm *positive* this isn't the right solution...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

