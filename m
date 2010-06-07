Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab0FGNJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 09:09:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:42323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab0FGNJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 09:09:19 -0400
Message-ID: <4C0CEF6F.8010108@kernel.org>
Date: Mon, 07 Jun 2010 15:09:03 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Marc Dionne <marc.c.dionne@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, garzik@redhat.com
Subject: Re: Hang during boot, bisected to commit 96d60303fd
References: <AANLkTiktNufXK_pn6mP2-zyowAIbHlUy5TGu3AtpALv-@mail.gmail.com> <20100603020006.GB19123@srcf.ucam.org> <AANLkTikpv86r5BBPCEOHujpm8uCgY0DxghSKjBufBWiM@mail.gmail.com> <4C08760B.8050002@gmail.com> <AANLkTimFY5YQv8DC-zTQ1RF84rno6svvcyLzHGWL6HOk@mail.gmail.com> <AANLkTimXcF1pafrSt8dMbUs59AjnqaRwpzDnPIPjdjsn@mail.gmail.com> <AANLkTinZ7d3WWyO3m9A7GVnaTuSbn1G33ADFW6ixywcT@mail.gmail.com> <AANLkTinIM8swHZTide7MAQsaYbWcFD90FrKUXE9NFG-5@mail.gmail.com> <4C0CBA5D.5000900@kernel.org> <AANLkTilwtazg_T4cX2EMb2xterwV1lhXdqUe3Q1UcsDN@mail.gmail.com> <20100607130419.GA8661@srcf.ucam.org>
In-Reply-To: <20100607130419.GA8661@srcf.ucam.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 07 Jun 2010 13:09:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/07/2010 03:04 PM, Matthew Garrett wrote:
> On Mon, Jun 07, 2010 at 08:21:42AM -0400, Marc Dionne wrote:
> 
>> With that patch the system boots normally.  Out of curiosity I also
>> instrumented ahci_error_handler a bit, and the stop_engine case
>> triggers once for the 6 unused ports, but doesn't trigger for the 2
>> ports with devices (SSD and DVD), as expected.
>>
>> Feel free to add a Tested-by if you submit it.
> 
> Well, that's what trusting the ahci spec gets me. Thanks for testing 
> that, Marc.

Heh heh, welcome to ATA.  :-)

Will add Tested-by and send it to Jeff.

Thanks.

-- 
tejun
