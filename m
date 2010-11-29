Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab0K2IDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:03:48 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:13548 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103Ab0K2IDr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:03:47 -0500
From: Shreyas Bhatewara <sbhatewara@vmware.com>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Scott Goldman <scottjg@vmware.com>
Date: Mon, 29 Nov 2010 00:03:45 -0800
Subject: RE: linux-next: Tree for November 26
Thread-Topic: linux-next: Tree for November 26
Thread-Index: AcuODnmji8dTNTojReOcAD108kbNHwBiHkFW
Message-ID: <89E2752CFA8EC044846EB8499819134102BD7E186A@EXCH-MBX-4.vmware.com>
References: <20101126132823.7ef94f07.sfr@canb.auug.org.au>,<AANLkTinJUT=j_P9FSB=GWTLy4Bkr68iWmB2O=5Q3gcT-@mail.gmail.com>
In-Reply-To: <AANLkTinJUT=j_P9FSB=GWTLy4Bkr68iWmB2O=5Q3gcT-@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reporting.
Thanks to Scott, the fix went in net-next tree, commit number : e9248fbd6b6f7ef1917bfffe998654e40dfb4cfd

->Shreyas

________________________________________
From: Zimny Lech [napohybelskurwysynom2010@gmail.com]
Sent: Saturday, November 27, 2010 12:38 AM
To: Stephen Rothwell
Cc: linux-next@vger.kernel.org; LKML; Shreyas Bhatewara; VMware, Inc.; netdev@vger.kernel.org
Subject: Re: linux-next: Tree for November 26

Ave

2010/11/26 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> Changes since 20101125:


  CC      drivers/net/vmxnet3/vmxnet3_drv.o
  CC      drivers/net/vmxnet3/vmxnet3_ethtool.o
/home/test/linux-2.6/drivers/net/vmxnet3/vmxnet3_ethtool.c: In
function 'vmxnet3_get_rss_indir':
/home/test/linux-2.6/drivers/net/vmxnet3/vmxnet3_ethtool.c:562:40:
error: 'struct vmxnet3_adapter' has no member named 'rss_conf'
/home/test/linux-2.6/drivers/net/vmxnet3/vmxnet3_ethtool.c: In
function 'vmxnet3_set_rss_indir':
/home/test/linux-2.6/drivers/net/vmxnet3/vmxnet3_ethtool.c:578:40:
error: 'struct vmxnet3_adapter' has no member named 'rss_conf'
make[4]: *** [drivers/net/vmxnet3/vmxnet3_ethtool.o] Error 1
make[3]: *** [drivers/net/vmxnet3] Error 2
make[2]: *** [drivers/net] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2



--
Slawa!
Zimny "¯yj i pozwól umrzeæ" Lech z Wawelu

That is not dead which can eternal lie.
And with strange aeons even death may die.