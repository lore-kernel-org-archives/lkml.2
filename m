Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2HVGl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:41:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2HVGlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:41:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: FW: [PATCH V5 0/5] clk: mmp: add clock framework for mmp
Date: Wed, 22 Aug 2012 06:41:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Chao Xie <xiechao.mail@gmail.com>, mturquette@ti.com,
        haojian.zhuang@gmail.com, mturquette@linaro.org,
        viresh.linux@gmail.com, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, chao.xie@marvell.com
References: <AAD1C6EB06EE3649B35B7E026785068D1A754366CB@SC-VEXCH2.marvell.com> <CADApbehnsRzwu_LrAEMf+L7AvXv+JBtPBOzWHj578Vs6B_LrCw@mail.gmail.com>
In-Reply-To: <CADApbehnsRzwu_LrAEMf+L7AvXv+JBtPBOzWHj578Vs6B_LrCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208220641.21891.arnd@arndb.de>
X-Provags-ID: V02:K0:YAzHByUrx31qubWhZcSoVFePOH7U2PYuFvUB3/hmzW5
 MtwCIXZcyTqicRI/HkORa+To73AOKzc8OKjPPyH8Qbjs5jUwtI
 AN4k1kUNrKQpOb502PQRdkoDGe2QfAX82ny8YCYOKl8HDmvPKd
 2hqnkIdTBBT5p9EYE4VSAVEZCoWkRkMGNcffU6FSy4CTJpgVFL
 xmcVvfwpwTQGoH6QMRNkOHgAoE5eoQRU9Op/Cm1onVIo/qPPDS
 yGjbqNoyGljasJwioKlXjX485LAPzEBkOJogVi2JEoUe99rkzo
 9MB3gK12u/Jxi+PydaCBt/6nf32PS16u3uWxZyne/CR+2/dCQt
 mlYd5nLM57BQWO6Xiptk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Chao Xie wrote:
> >
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> >
> >         Arnd
> 
> Who will be responsible for merging these patches?
> 

They should go through Mike's tree, unless there is a reason why he
prefers them to go through arm-soc. It would be helpful to add
an 'Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>' line
and my 'Reviewed-by: Arnd Bergmann <arnd@arndb.de>' line to each
patch for that.

	Arnd
