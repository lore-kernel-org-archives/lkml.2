Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2LZMhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 07:37:16 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:55537 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2LZMhO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 07:37:14 -0500
References: <50DAC90D.6020902@aixigo.de>
Mime-Version: 1.0 (1.0)
In-Reply-To: <50DAC90D.6020902@aixigo.de>
Content-Type: text/plain;
	charset=GB2312
Content-Transfer-Encoding: 8BIT
Message-Id: <165B007B-9868-42C1-AA4F-E5941EEB860B@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPad Mail (10A523)
From: ethan <ethan.kernel@gmail.com>
Subject: Re: strange kernel log messages
Date: Wed, 26 Dec 2012 20:37:04 +0800
To: Harald Dunkel <harald.dunkel@aixigo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe you got something wrong with USB 3.0 driver and its devices, U'd better reach USB guys.

Ethan

ÔÚ 2012-12-26£¬17:53£¬Harald Dunkel <harald.dunkel@aixigo.de> Ð´µÀ£º

> Hi folks,
> 
> I get a lot of strange messages in /var/log/kern.log:
> 
> :
> Dec 26 08:01:58 dpcl082 kernel: <>[1862186]xc_c 000:00 RO oro ne ig<>1862143]hb5110 ciae->-23862114]xc_c 000:00 RO oro ne ig<>1862186]hb5110 ciae->-231862075]xc_c 000:00 RO oro ne ig<>1862140]hb5110 ciae->-2<>[1872078]xc_c 000:00 RO oro ne ig<>1872074]xc_c 000:00 RO oro ne ig<>1872031]hb5110 ciae->-2<>1872064]xc_c 000:00 RO oro ne ig<>1872039]hb5110 ciae->-2<>1881965]xc_c 000:00 RO oro ne ig<>1882033]hb5110 ciae->-23[794.753 hihd00:60.:ERRn omo prn
> Dec 26 08:03:58 dpcl082 kernel: <>1881961]xc_c 000:00 RO oro ne ig<3>[1789871.993215]hb5110 ciae->-2<>1891961]xc_c 000:00 RO oro ne ig<>1891927]hb5110 ciae->-2<>1891957]xc_c 000:00 RO oro ne ig<>1891929]hb5110 ciae->-2<>[1796.954 hihd00:60.:ERRn omo prn
> Dec 26 08:03:58 dpcl082 kernel: 3[796.330 u -:.:atvt - 1
> Dec 26 08:04:28 dpcl082 kernel: <>[799.730 hihd00:60.:ERRn omo prn
> Dec 26 08:04:28 dpcl082 kernel: 3[799.116 u -:.:atvt - 1
> Dec 26 08:05:58 dpcl082 kernel: <>1901890]xc_c 000:00 RO oro ne ig<>1901862]hb5110 ciae->-2<>1901847]xc_c 000:00 RO oro ne ig<>1901810]hb5110 ciae->-23[708.173 hihd00:60.:ERRn omo prn
> Dec 26 08:05:58 dpcl082 kernel: 3[708.553 u -:.:atvt - 1
> Dec 26 08:06:58 dpcl082 kernel: <>1911747]xc_c 000:00 RO oro ne ig<>1911817]hb5110 ciae->-2<3>[1790141.774230] xhci_hcd 0000:06:00.0: ERROR no room on ep ring
> Dec 26 08:07:58 dpcl082 kernel: 3[700.770 u -:.:atvt - 1
> Dec 26 08:11:28 dpcl082 kernel: 3[701.224 u -:.:atvt - 1
> :
> 
> What is it trying to tell me? Sorry for asking, but Google
> did not help.
> 
> Kernel is 3.2.0-0.bpo.4-amd64 from Squeeze backports.
> 
> 
> Regards
> Harri
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
