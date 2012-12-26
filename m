Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab2LZKXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 05:23:32 -0500
Received: from mail.aixigo.de ([80.149.209.52]:52981 "EHLO mail.aixigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab2LZKXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 05:23:31 -0500
X-Greylist: delayed 1804 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 05:23:30 EST
Message-ID: <50DAC90D.6020902@aixigo.de>
Date: Wed, 26 Dec 2012 10:53:17 +0100
From: Harald Dunkel <harald.dunkel@aixigo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: strange kernel log messages
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I get a lot of strange messages in /var/log/kern.log:

:
Dec 26 08:01:58 dpcl082 kernel: <>[1862186]xc_c 000:00 RO oro ne ig<>1862143]hb5110 ciae->-23862114]xc_c 000:00 RO oro ne ig<>1862186]hb5110 ciae->-231862075]xc_c 000:00 RO oro ne ig<>1862140]hb5110 ciae->-2<>[1872078]xc_c 000:00 RO oro ne ig<>1872074]xc_c 000:00 RO oro ne ig<>1872031]hb5110 ciae->-2<>1872064]xc_c 000:00 RO oro ne ig<>1872039]hb5110 ciae->-2<>1881965]xc_c 000:00 RO oro ne ig<>1882033]hb5110 ciae->-23[794.753 hihd00:60.:ERRn omo prn
Dec 26 08:03:58 dpcl082 kernel: <>1881961]xc_c 000:00 RO oro ne ig<3>[1789871.993215]hb5110 ciae->-2<>1891961]xc_c 000:00 RO oro ne ig<>1891927]hb5110 ciae->-2<>1891957]xc_c 000:00 RO oro ne ig<>1891929]hb5110 ciae->-2<>[1796.954 hihd00:60.:ERRn omo prn
Dec 26 08:03:58 dpcl082 kernel: 3[796.330 u -:.:atvt - 1
Dec 26 08:04:28 dpcl082 kernel: <>[799.730 hihd00:60.:ERRn omo prn
Dec 26 08:04:28 dpcl082 kernel: 3[799.116 u -:.:atvt - 1
Dec 26 08:05:58 dpcl082 kernel: <>1901890]xc_c 000:00 RO oro ne ig<>1901862]hb5110 ciae->-2<>1901847]xc_c 000:00 RO oro ne ig<>1901810]hb5110 ciae->-23[708.173 hihd00:60.:ERRn omo prn
Dec 26 08:05:58 dpcl082 kernel: 3[708.553 u -:.:atvt - 1
Dec 26 08:06:58 dpcl082 kernel: <>1911747]xc_c 000:00 RO oro ne ig<>1911817]hb5110 ciae->-2<3>[1790141.774230] xhci_hcd 0000:06:00.0: ERROR no room on ep ring
Dec 26 08:07:58 dpcl082 kernel: 3[700.770 u -:.:atvt - 1
Dec 26 08:11:28 dpcl082 kernel: 3[701.224 u -:.:atvt - 1
:

What is it trying to tell me? Sorry for asking, but Google
did not help.

Kernel is 3.2.0-0.bpo.4-amd64 from Squeeze backports.


Regards
Harri
