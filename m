Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2HGQdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:33:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48655 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab2HGQdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:33:04 -0400
Message-ID: <5021432F.2030907@zytor.com>
Date: Tue, 07 Aug 2012 09:32:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: zhenzhong.duan@oracle.com
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] Parallelize mtrr init between cpus
References: <5020C3D7.2070407@oracle.com>
In-Reply-To: <5020C3D7.2070407@oracle.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 12:29 AM, zhenzhong.duan wrote:
> Current code serialize mtrr init with set_atomicity_lock.
> Mtrr init is quite slow when we bootup on a hvm with large mem, vcpus
> and pci passthroughed devices(eg. 24 vcpus + 90G mem).
> It took about ~30 mins to bootup, after patch, it took ~2 min.

When you're saying "HVM" do you mean "Xen HVM"?  How does it behave on
native hardware?

	-hpa

