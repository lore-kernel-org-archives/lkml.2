Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0DLJuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:50:32 -0400
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:45458 "EHLO
	mail-out1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab0DLJub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 05:50:31 -0400
Message-ID: <4BC2ECE4.1020704@mathtm.de>
Date: Mon, 12 Apr 2010 11:50:28 +0200
From: =?ISO-8859-1?Q?Thomas_M=FCller?= <thomas@mathtm.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       maciej.rutecki@gmail.com, rusty@rustcorp.com.au, mashirle@us.ibm.com,
       xma@us.ibm.com
Subject: Re: [Bug #15719] virtio_net causing kernel BUG when running under
 VirtualBox
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>	<JVS2s9dmTsP.A.6eF.xsPvLB@chimera>	<4BC2DC5A.6090007@mathtm.de> <20100412.022828.52192543.davem@davemloft.net>
In-Reply-To: <20100412.022828.52192543.davem@davemloft.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12.04.2010 11:28, David Miller wrote:
>> a fix (commit 2c45cd43ff791cc4ab6a6332165ad53d7bcb3673) is included in
>> linux-next and net-next, but not (yet?) in linux-2.6.
> 
> This bug was only present in -next and net-next-2.6 to the best of
> my knowledge, so the fix only showing up there is appropriate.

I think I have to disagree.

I hit this bug with a clean checkout of linux-2.6 and I also bisected
against the linux-2.6 repo.
(I did however use a Fedora rawhide kernel config as starting point,
so presumably there were a lot of debug options activated)

When Shirley Ma sent the fix, I did verify that linux-2.6 without
the fix did not work, and that everything worked fine with it applied.


Regards,
Thomas
