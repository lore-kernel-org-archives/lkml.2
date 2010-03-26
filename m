Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab0CZMMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:12:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab0CZMMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:12:23 -0400
Date: Fri, 26 Mar 2010 13:10:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: Can not boot with CONFIG_NO_BOOTMEM=y on i686
Message-ID: <20100326121026.GA2962@dhcp-lab-161.englab.brq.redhat.com>
References: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com> <86802c441003201126j407eaf89j91cf91ae69454f30@mail.gmail.com> <20100323113551.GA3862@dhcp-lab-161.englab.brq.redhat.com> <4BA98FA8.1040600@kernel.org> <20100324090438.GA7512@dhcp-lab-161.englab.brq.redhat.com> <4BAC6C03.3030801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAC6C03.3030801@kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 01:10:43AM -0700, Yinghai Lu wrote:
> Please check if this one helps

Yes. Kernel with both patches provided in this thread
boot with CONFIG_NO_BOOTMEM=y.

Thanks!

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
