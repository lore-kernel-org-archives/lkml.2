Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1JHLbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 07:31:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52251 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1JHLbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 07:31:43 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 24/26] ARM: pxa: centro and treo680 need palm27x
Date: Sat, 8 Oct 2011 13:31:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-25-git-send-email-arnd@arndb.de> <CAMPhdO9hTC0_30Oxc+ndn5EstOEMQKa7E_MEf4jn7ipTBbhBfw@mail.gmail.com>
In-Reply-To: <CAMPhdO9hTC0_30Oxc+ndn5EstOEMQKa7E_MEf4jn7ipTBbhBfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110081331.41414.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 08, 2011 12:20:57 PM Eric Miao wrote:
> On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > The two platforms are part of the palm27x family and use the same
> > code. Select the palm27x symbol to make sure they can be built
> > standalone.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Applied.

Thanks Eric.
