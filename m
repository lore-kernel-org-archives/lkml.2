Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0KDPhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:37:24 -0400
Received: from mailout1.paradigmgeo.com ([12.146.216.194]:44801 "EHLO
	mailout1.paradigmgeo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0KDPhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:37:22 -0400
From: Gregory Giguashvili <Gregory.Giguashvili@PDGM.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Change signal mask after vfork/clone system call
Thread-Topic: Change signal mask after vfork/clone system call
Thread-Index: ActvYrwDS1Qou4ZiSWG8vicGxd93awMg65jwAAOOfoAAEApcQA==
Date: Thu, 4 Nov 2010 15:37:05 +0000
Message-ID: <DAF636D3923A51488784A1F985996EE804206DDF@exil1.paradigmgeo.net>
References: <DAF636D3923A51488784A1F985996EE803FCB7B0@exil1.paradigmgeo.net>
	<DAF636D3923A51488784A1F985996EE8041FAA46@exil1.paradigmgeo.net>
 <20101104094817.21548963@lxorguk.ukuu.org.uk>
In-Reply-To: <20101104094817.21548963@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.3.201]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Nov 2010 15:37:07.0628 (UTC) FILETIME=[238666C0:01CB7C36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fork on pretty much any Unix like system around today does copy-on-write
>so while not as efficient as vfork should be fine for most purposes.
Yes, but the problem is that fork simply does not work when a process has huge resident size and vm.overcommit_memory=0 as preferred by Linux distributions we run on. So, processes with large RSS footprint may occasionally fail fork, even if a tiny process is to be started.

Using vfork always works, but has the signal mask problem. Catch 22?

Giga

---------------------------------------------------------------------------------------------------------------
This e-mail, including any attached files, may contain confidential and privileged information for the sole use of the intended recipient. Any review, use, distribution, or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive information for the intended recipient), please contact the sender by reply e-mail and delete all copies of this message.


