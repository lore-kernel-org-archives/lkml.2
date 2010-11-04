Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab0KDQoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 12:44:09 -0400
Received: from mailout1.paradigmgeo.com ([12.146.216.194]:45099 "EHLO
	mailout1.paradigmgeo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab0KDQoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 12:44:07 -0400
From: Gregory Giguashvili <Gregory.Giguashvili@PDGM.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Change signal mask after vfork/clone system call
Thread-Topic: Change signal mask after vfork/clone system call
Thread-Index: ActvYrwDS1Qou4ZiSWG8vicGxd93awMg65jwAAOOfoAAEApcQP//44qA///XZgCAADSMAP//2wLg
Date: Thu, 4 Nov 2010 16:43:53 +0000
Message-ID: <DAF636D3923A51488784A1F985996EE804207140@exil1.paradigmgeo.net>
References: <DAF636D3923A51488784A1F985996EE803FCB7B0@exil1.paradigmgeo.net>
	<DAF636D3923A51488784A1F985996EE8041FAA46@exil1.paradigmgeo.net>
	<20101104094817.21548963@lxorguk.ukuu.org.uk>
	<DAF636D3923A51488784A1F985996EE804206DDF@exil1.paradigmgeo.net>
	<20101104154543.2a71cff1@lxorguk.ukuu.org.uk>
	<DAF636D3923A51488784A1F985996EE804207065@exil1.paradigmgeo.net>
 <20101104162828.7862a49d@lxorguk.ukuu.org.uk>
In-Reply-To: <20101104162828.7862a49d@lxorguk.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.3.201]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 04 Nov 2010 16:43:55.0061 (UTC) FILETIME=[78242650:01CB7C3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh you are wrapping buggy apps ?
The applications are not buggy. They're just unaware of signals being blocked. It's a common practice to set a signal, but not to reset signal mask unfortunately.

> exec a tiny app which fixes the signals and execs the proper app
Yes, this is the last resort of course. I was wondering if I'm missing some functionality in Linux allowing me to avoid intermediate executables. It looks like I have to go via a wrapper exe.

Thank you for your comments,
Giga


---------------------------------------------------------------------------------------------------------------
This e-mail, including any attached files, may contain confidential and privileged information for the sole use of the intended recipient. Any review, use, distribution, or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive information for the intended recipient), please contact the sender by reply e-mail and delete all copies of this message.


