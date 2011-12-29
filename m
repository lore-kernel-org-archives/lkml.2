Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1L2Qtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 11:49:40 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51509 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754571Ab1L2Qti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 11:49:38 -0500
Message-ID: <4EFC9A1D.4000601@lwfinger.net>
Date: Thu, 29 Dec 2011 10:49:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Andiry Xu <andiry.xu@amd.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, v4mp <gaigo88@hotmail.it>
Subject: Re: Question about error from xhci-hcd
References: <4EAC3C5C.5000209@lwfinger.net> <20111030050443.GC4535@xanatos> <4EB01904.10605@lwfinger.net> <4EC0DCD5.2010509@amd.com> <4EFB4429.4090002@lwfinger.net> <4EFBDF35.8000501@amd.com> <4EFBE4B2.5000801@lwfinger.net> <4EFBECE1.2060001@amd.com>
In-Reply-To: <4EFBECE1.2060001@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2011 10:30 PM, Andiry Xu wrote:
>
> That's the error I want to see, but I didn't find it in the dmesg you
> posted. is it wrapped?
>
> Anyway, please post the full dmesg with no room on ring error and the
> dump of the ep ring and event ring (so the xhci_debug_ring() is
> triggered in the patch), so we can see if the ring is mangled or there
> is just too many transfers.
>
> Another thing you can try is the andiry-ring-expansion branch on Sarah's
> xhci git tree, check if there is still no room on ring error.

No, the ring is not wrapped. I seems that my anti-spam mechanism kicked in too 
soon. or the run stopped too soon.

I'll have the OP do another run and see if we can get the right information.

Larry
