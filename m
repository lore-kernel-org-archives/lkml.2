Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2JCVDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:03:21 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:42018
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754919Ab2JCVDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:03:19 -0400
Message-ID: <506CA7EA.2080505@chelsio.com>
Date: Wed, 03 Oct 2012 14:02:34 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, David Woodhouse <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Subject: pull request: linux-firmware: update cxgb4 firmware
References: <20120928183029.41d151b6@zola.asicdesigners.com>
In-Reply-To: <20120928183029.41d151b6@zola.asicdesigners.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2012 6:30 PM, Divy Le Ray wrote:
> Hi,
>
> Can you please pull from the following URL?
>      git://git.chelsio.net/pub/git/linux-firmware.git for-upstream

Hi,

Is there any problem with this pull request?

Cheers,
Divy

>
> The following changes since commit 236367db10f1e618a3ced2538f5cd1802c31ebd8:
>    Yuval Mintz (1):
>         bnx2x: update fw to 7.8.2
>
> are available in the git repository at:
>   git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
>
> Divy Le Ray (1):
>       cxgb4: update firmware to revision 1.6.2.0
>
>   WHENCE                  |    2 +-
>   cxgb4/t4fw-1.4.23.0.bin |  Bin 326144 -> 0 bytes
>   cxgb4/t4fw-1.6.2.0.bin  |  Bin 0 -> 431616 bytes
>   cxgb4/t4fw.bin          |    2 +-
>   4 files changed, 2 insertions(+), 2 deletions(-)
>   delete mode 100644 cxgb4/t4fw-1.4.23.0.bin
>   create mode 100644 cxgb4/t4fw-1.6.2.0.bin
>
> Cheers,
> Divy


