Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab2IUQUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:20:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61272 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab2IUQUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:20:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 01/11] ARM: defconfig: Remove CONFIG_MISC_DEVICES
Date: Fri, 21 Sep 2012 14:49:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        linux-arm-kernel@lists.infradead.org
References: <1345307035-3545-1-git-send-email-festevam@gmail.com> <CAOMZO5C2ihKUeQk17JOHc9VXAB3KTeQLS3OcLOiiUC8jucsexg@mail.gmail.com> <CAOMZO5C2rTBM6si0MUC7XWznwqwmUq5-LmFyekLab8UBVwaCFw@mail.gmail.com>
In-Reply-To: <CAOMZO5C2rTBM6si0MUC7XWznwqwmUq5-LmFyekLab8UBVwaCFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211449.56906.arnd@arndb.de>
X-Provags-ID: V02:K0:7NKVNPrlgiX4O84KmmG3IEKLy0Uyh3h9lw5qw2sLxpu
 gyZCwSqvrk9Ri+uyaJoPcCqvqF5IAAjeCcd25JKzbsQnyCYyd1
 T/N6nGTbyV0m3ZoxeZO8TXasSiTbn4+1fL0Q3hsYIe6kLngS4j
 Fk+W18vK17vy+HUZfci545USrsY83VWCtZNQVH6Q6HKRS0Jps1
 75vh/3VYj4exZCUaJ3cfZv6BcJm19Q8FRj5xmTcBviMEe+PN1b
 Dc3ttLZEhA3esABTlRd3zkU60V7esnz3sfV+gUDGMMa7YilBO0
 Tr8wFOs5rI0LIiLEKx3IMs+YtQBvuGodVfcxCG5ZtiuH52Pngt
 XGJZ6yx1I6h9JfQUfok0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 September 2012, Fabio Estevam wrote:
> Hi Arnd,
> 
> On Thu, Sep 6, 2012 at 7:25 PM, Fabio Estevam <festevam@gmail.com> wrote:
> 
> > I am not sure who would pick up this series.
> >
> > Is it possible for you to apply these patches?
> 
> Is this something you can help with?
> 

Hi Fabio,

Sorry for not replying earlier. We could merge these through the
arm-soc tree, but I'm not actually sure if they are necessary.

For all I know, listing a nonexisting configuration option in
a defconfig file has no effect, and the files get recreated
whenever the maintainers choose to.

Is there anything I am missing?

	Arnd

