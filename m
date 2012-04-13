Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab2DMMro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:47:44 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:12430 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab2DMMrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:47:42 -0400
Message-ID: <4F882043.1090006@atmel.com>
Date: Fri, 13 Apr 2012 14:46:59 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mmc tree
References: <20120412140206.704731281bf2ee7d93d582bf@canb.auug.org.au> <87pqbdr1md.fsf@laptop.org>
In-Reply-To: <87pqbdr1md.fsf@laptop.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 06:54 AM, Chris Ball :
> Hi,
> 
> On Thu, Apr 12 2012, Stephen Rothwell wrote:
>> Today's linux-next merge of the arm-soc tree got a conflict in
>> drivers/mmc/host/Kconfig between commit a334b9550294 ("mmc: remove imxmmc
>> driver") from the mmc tree and commits a21a92c0c787 ("mmc: Kconfig: remove
>> choice between at91_mci and atmel-mci") and 62080f06de6b ("mmc:
>> atmel-mci: remove the need for CONFIG_MMC_ATMELMCI_DMA") from the arm-soc
>> tree.
>>
>> I fixed it up (see below) and can carry the fix as necessary.
> 
> Thanks, Stephen.
> 
> Nicolas and Arnd, these MMC Kconfig patches weren't sent to me or
> linux-mmc@ for review, so I haven't seen them before.  They look
> fine, but I'd like to be in the loop directly to avoid surprises.

Yes Chris, my fault here, it is true that I should have send those
patches to you and linux-mmc.

> Do these MMC patches have any dependency on other work?  It doesn't
> look like it.  If that's so, I'd rather carry them in the MMC tree
> to save Stephen and Linus from dealing with the merge conflict.

Indeed, and in the meantime, it seems that these Kconfig modifications
are not as harmless as the others in the series.

I propose to redo a pull request without those two patches. We will
resend them directly through the MMC subsystem together with other
mmc-related fixes. Moreover, all this will probably make more sense as
3.5 modifications...

Best regards,
-- 
Nicolas Ferre
