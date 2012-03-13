Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab2CMMdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:33:03 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:47400 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab2CMMdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:33:01 -0400
Message-ID: <4F5F3E79.5030809@ge.com>
Date: Tue, 13 Mar 2012 12:32:57 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v3 4/4] powerpc: Board support for GE IMP3A
References: <1331572380-1064-1-git-send-email-martyn.welch@ge.com>	<1331572380-1064-5-git-send-email-martyn.welch@ge.com> <CACRpkdZv84PKts4jFscsNcOq6rggZXSYzu3CBe8NFDTPwsd1aw@mail.gmail.com>
In-Reply-To: <CACRpkdZv84PKts4jFscsNcOq6rggZXSYzu3CBe8NFDTPwsd1aw@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2012 12:32:59.0548 (UTC) FILETIME=[6CD56DC0:01CD0115]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/12 11:51, Linus Walleij wrote:
> On Mon, Mar 12, 2012 at 6:13 PM, Martyn Welch <martyn.welch@ge.com> wrote:
> 
>> Initial board support for the GE IMP3A, a 3U compactPCI card with a p2020
>> processor.
> (...)
>> +++ b/arch/powerpc/configs/ge_imp3a_defconfig
>> @@ -0,0 +1,257 @@
>> +CONFIG_PPC_85xx=y
>> +CONFIG_SMP=y
>> +CONFIG_NR_CPUS=2
>> +CONFIG_EXPERIMENTAL=y
>> +CONFIG_SYSVIPC=y
>> +CONFIG_POSIX_MQUEUE=y
>> +CONFIG_BSD_PROCESS_ACCT=y
>> +CONFIG_BSD_PROCESS_ACCT_V3=y
>> +CONFIG_SPARSE_IRQ=y
> 
> This habit of changing a lot of defconfig stuff in a patch dealing with other
> stuff is alien in the ARM world. Especially when changing a horde of stuff
> that has nothing to do with the patch subject.
> 

This is adding the defconfig, it's support for a new board:

diff --git a/arch/powerpc/configs/ge_imp3a_defconfig
b/arch/powerpc/configs/ge_imp3a_defconfig
new file mode 100644
index 0000000..f8c51a4
--- /dev/null
+++ b/arch/powerpc/configs/ge_imp3a_defconfig


> But I don't really know how PPC does these things so who am I to
> speak ...
> 
> BTW: doesn't the "make saveconfig" reduce defconfigs on PPC?
> Paging Uwe on this.

This is the output of "make savedefconfig".

Martyn

-- 
Martyn Welch (Lead Software Engineer)  | Registered in England and Wales
GE Intelligent Platforms               | (3828642) at 100 Barbirolli Square
T +44(0)1327322748                     | Manchester, M2 3AB
E martyn.welch@ge.com                  | VAT:GB 927559189
