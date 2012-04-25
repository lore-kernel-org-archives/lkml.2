Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab2DYJfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:35:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab2DYJfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:35:09 -0400
Message-ID: <4F97C545.4030304@redhat.com>
Date: Wed, 25 Apr 2012 12:35:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 24 (kvm)
References: <20120424154354.7feba600beac616833d034de@canb.auug.org.au> <4F96D3FA.1010909@xenotime.net>
In-Reply-To: <4F96D3FA.1010909@xenotime.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 07:25 PM, Randy Dunlap wrote:
> On 04/23/2012 10:43 PM, Stephen Rothwell wrote:
>
> > Hi all,
> > 
> > There will probably be no linux-next release until April 30 as I am
> > taking a break.
> > 
> > Changes since 20120423:
>
>
> on i386:
>
>   CC [M]  arch/x86/kvm/emulate.o
> arch/x86/kvm/emulate.c: Assembler messages:
> arch/x86/kvm/emulate.c:4122: Error: bad register name `%bpl'
>
>

Fix already committed, will be pushed later today.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

