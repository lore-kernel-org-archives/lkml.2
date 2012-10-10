Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2JJAAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:00:32 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61370 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2JJAAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:00:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUL=0+TfUHKdcV-OGhGbtoarHU-3ch3kqz7NmqhBPWvwQ@mail.gmail.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210091316570.29539@kaball.uk.xensource.com>
	<CAE9FiQUL=0+TfUHKdcV-OGhGbtoarHU-3ch3kqz7NmqhBPWvwQ@mail.gmail.com>
Date: Tue, 9 Oct 2012 17:00:20 -0700
X-Google-Sender-Auth: TbAZClknpfxBRNGDCN8mN4PGW98
Message-ID: <CAE9FiQWE9RUpkpGrFoUE9sPfG5asp+=gYa9K3n7JVQ7J2DzmGg@mail.gmail.com>
Subject: Re: [PATCH -v2 00/10] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 11:27 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Oct 9, 2012 at 5:19 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
>>
>> I agree with Peter that this series is going in the right direction.
>> However if I give more than 4G of RAM to the VM I get a panic at boot:

just update my branch for-x86-mm, and it should fix the panic problem....

please try it again.

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm

Thanks a lot!

Yinghai
