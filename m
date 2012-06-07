Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2FGLof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 07:44:35 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47275 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2FGLoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 07:44:34 -0400
MIME-Version: 1.0
In-Reply-To: <4FD01229.4020607@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
	<20120529133627.GA7637@shutemov.name>
	<20120529154308.GA10790@dhcp-27-244.brq.redhat.com>
	<20120531180834.GP21339@redhat.com>
	<4FD01229.4020607@redhat.com>
Date: Thu, 7 Jun 2012 19:44:33 +0800
Message-ID: <CAJd=RBAQiKC1Np7qzNrD1AEXcoPwfSLwTh9ZjUkvAb7F6eUX9A@mail.gmail.com>
Subject: Re: AutoNUMA15
From: Hillf Danton <dhillf@gmail.com>
To: Zhouping Liu <zliu@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhouping

On Thu, Jun 7, 2012 at 10:30 AM, Zhouping Liu <zliu@redhat.com> wrote:
>
> [    3.114024] ---[ end trace e696d6ddf3adb276 ]---
> [    3.121541] swapper/0 used greatest stack depth: 4768 bytes left
> [    3.143784] Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x0000000b
> [    3.143784]
>
> such above errors occurred in my two boxes:
> in one machine, which has 120Gb RAM and 8 numa nodes with AMD CPU, kernel
> panic occurred in autonuma15 and Linus tree(3.5.0-rc1)
> but in another one, which has 16Gb RAM and 4 numa nodes with AMD CPU, kernel
> panic only occurred in autonuma15, no such issues in Linus tree,
>
Related to fix at https://lkml.org/lkml/2012/6/5/31  ?
