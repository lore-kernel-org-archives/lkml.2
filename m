Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1DGNMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:12:55 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:16559 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab1DGNMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:12:54 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFIiy0PGjDB
X-RZG-CLASS-ID: mo00
Date: Thu, 7 Apr 2011 15:12:50 +0200
From: Olaf Hering <olaf@aepfle.de>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: dynamic oldmem in kdump kernel
Message-ID: <20110407131250.GA1571@aepfle.de>
References: <20110407095646.GA30788@aepfle.de>
 <BANLkTimXRcKyWdUxS2TRzibcSUdCfObH3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimXRcKyWdUxS2TRzibcSUdCfObH3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, Américo Wang wrote:

> On Thu, Apr 7, 2011 at 5:56 PM, Olaf Hering <olaf@aepfle.de> wrote:
> > Another issue, slightly related, is memory hotplug.
> > How is this currently handled for kdump?  Is there code which
> > automatically reconfigures the kdump kernel with the new memory ranges?
> >
> 
> No, the crashkernel memory is reserved during boot, and it is static after
> that (except you can shrink this memory via /sys).

I meant the overall amount of memory changed by memory hotplug events,
not the small memory range for the crash kernel itself.

> Kdump isn't aware of memory hotplug.

Ok.  Perhaps there are hotplug events where a helper script could run
something like 'rckdump restart'.

Olaf
