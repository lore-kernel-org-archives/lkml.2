Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2FKP2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:28:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab2FKP2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:28:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH V2 0/6] Bridging PCI to amba
Date: Mon, 11 Jun 2012 15:28:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <cover.1338220457.git.rubini@gnudd.com> <CACRpkdbPtR5MDjd1YZ5GhOdp61HQe2PJusudNPOhDQHUAt1kJA@mail.gmail.com>
In-Reply-To: <CACRpkdbPtR5MDjd1YZ5GhOdp61HQe2PJusudNPOhDQHUAt1kJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111528.23034.arnd@arndb.de>
X-Provags-ID: V02:K0:KybUt5ODjUI2X+NDDABqTDTbnQKuzkOiLGMDH6cMDcX
 WdWZZxe1W7EQAeBfXyxoUJpr9Ib+M6MRAKUjxLE9YPYMFK1DW2
 UXSuQKxPRaBCjLjbPDZzFPE+zPjMepMnIOhzTYUCJIE8ekeyRx
 uQSiX76CRBHgoJdfiKQrLNw2gbAvZNbq3vb4v8dyyeBao/KLDf
 8UUL1VAKdo2P6meL7Mci3lRgzUUtteWiKGA79W4hb2/xhafkh5
 JYQG4HkjLTqPATWpiCLZZE/UF9vd0lMxJo4PhpEoJV9jK1v2W8
 ZyHPs4wW6Wkd0OToZpdTnXlDsAXh/Ob+fdE6vWu67u1ajesg6+
 ZBXff9fE/FH7A/xy9pTI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 June 2012, Linus Walleij wrote:
> On Mon, May 28, 2012 at 6:36 PM, Alessandro Rubini <rubini@gnudd.com> wrote:
> 
> > V2: accepted comments I got on V1; rewritten the driver to be generic;
> >    made it tristate instead of boolean. Rebased on new next.
> 
> This looks good to me.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I think this patch set could go through Arnd as arch maintainer?
> It's fun with these cross-arch things. You'll need an ACK from
> Russell first.

I don't think it has much to do with code I maintain. Russell
as the Primecell maintainer is the right person to take it through
his tree.

	Arnd
