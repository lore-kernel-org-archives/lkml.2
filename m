Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab0KEHdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:33:02 -0400
Received: from mailout1.paradigmgeo.com ([12.146.216.194]:46914 "EHLO
	mailout1.paradigmgeo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0KEHc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:32:59 -0400
From: Gregory Giguashvili <Gregory.Giguashvili@PDGM.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Change signal mask after vfork/clone system call
Thread-Topic: Change signal mask after vfork/clone system call
Thread-Index: ActvYrwDS1Qou4ZiSWG8vicGxd93awMg65jwAAOOfoAAMbLtcA==
Date: Fri, 5 Nov 2010 07:32:44 +0000
Message-ID: <DAF636D3923A51488784A1F985996EE80422C6C2@exil1.paradigmgeo.net>
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
X-OriginalArrivalTime: 05 Nov 2010 07:32:45.0918 (UTC) FILETIME=[A3CF1FE0:01CB7CBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Finally, if using fork should be efficient for starting processes from applications with heavy VM/RSS memory footprint, > this question becomes obsolete.

What about posix_spawn API? It allows for resetting signal mask for the child process, but does it belong to fork or vfork "family"?

Giga
---------------------------------------------------------------------------------------------------------------
This e-mail, including any attached files, may contain confidential and privileged information for the sole use of the intended recipient. Any review, use, distribution, or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive information for the intended recipient), please contact the sender by reply e-mail and delete all copies of this message.


