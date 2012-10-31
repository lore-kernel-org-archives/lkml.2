Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935549Ab2JaNEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:04:20 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:19939
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932864Ab2JaNER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:04:17 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Oct 2012 09:04:17 EDT
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537hbe9i1155h)
Subject: [alsa-devel] Query about alsa ucm (use case manager) config files
From: Ashish Chavan <ashish.chavan@kpitcummins.com>
To: lrg <lrg@ti.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel <alsa-devel@alsa-project.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Oct 2012 18:29:32 +0530
Message-ID: <1351688372.28030.18.camel@matrix>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.20.243]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I am just curious to know if there is any centralized repository for
alsa use case manager configuration files. I tried searching and could
only find alsa-ucm-conf.git repo at alsa project git server, which is
actually an empty repo!

How people share/reuse ucm configuration files for a specific codec?
In near future, I will be developing few ucm configuration files for
some codecs and wish to share them with rest of the world. I think even
though ucm configs are board/machine specific, it makes sense to share
them. Is there any other, more visible place to put these config files
than board specific distributions?


