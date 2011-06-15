Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1FOQ7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:59:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56566 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1FOQ7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:59:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:subject:message-id:from:to:cc:mime-version:content-type
         :content-transfer-encoding;
        b=LHwvcQkkYt35pirZ46enEcaZZZwJtNUIQVo66wk9CEsQL5iZAK0EumvIk4JYy0Nwfu
         b73SYrfZWPNmbAa/ggWNLHmRQf86c1G1XNrfhMljrxAMXyiKUeplBvoLeHPaKAWNSmur
         VTccS3TaJIraP/MIavOAtyf0q7usX0N8TiptM=
Date: Thu, 16 Jun 2011 00:59:02 +0800
Subject: Re: Build regressions/improvements in v3.0-rc3
Message-ID: <0xiwxbi65vqbt219v1nmfc06.1308157106118@email.android.com>
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5FGxNps020785

Maybe linus had missed them, sadly.

Ralf Baechle <ralf@linux-mips.org> wrote:

>On Wed, Jun 15, 2011 at 10:29:32PM +1000, Stephen Rothwell wrote:
>
>> On Wed, 15 Jun 2011 19:44:41 +0800 Wanlong Gao <wanlong.gao@gmail.com> wrote:
>> >
>> > <snip>
>> > I see that some mips fixes in ralf's tree but not been pulled. almost
>> > for about one month.
>> 
>> Well, the mips tree in linux-next is
>> git://git.linux-mips.org/pub/scm/upstream-sfr.git#mips-for-linux-next and
>> I fetch it every day.
>
>I only have the new bits in linux-next but not the pending for the current
>work-in-progress kernel, that is 3.0.  Those are queued in
>
>http://git.linux-mips.org/?p=upstream-linus.git;a=summary
>git://git.linux-mips.org/pub/scm/upstream-linus.git
>
>and I've sent two pull requests to Linus so far which went without
>reaction ...
>
>  Ralf
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
