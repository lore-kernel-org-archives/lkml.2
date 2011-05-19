Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab1ESPCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:02:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab1ESPCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:02:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 6/7] tty/powerpc: introduce the ePAPR embedded hypervisor byte channel driver
Date: Thu, 19 May 2011 17:02:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: kumar.gala@freescale.com, benh@kernel.crashing.org, greg@kroah.com,
        akpm@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1305813272-31826-1-git-send-email-timur@freescale.com> <1305813272-31826-7-git-send-email-timur@freescale.com>
In-Reply-To: <1305813272-31826-7-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191702.39919.arnd@arndb.de>
X-Provags-ID: V02:K0:uojEeYNU4NQItDfST8frFgk1HORBde5Vkt4InZBuCiN
 TGGjxuGjSxHTVHK3WWRsh+sKbe7UH6CSUcJ/giOkpKPHlVaXkY
 QQxYJ90YhMIietesh+M6cyI1rQjeRCVeQA31QD/EkxrfRqzG0Z
 p1Yn4BYicgJvOFI+R8YgSmtqm4ZIM9k6vFEoSpR+40VYgnWrR2
 k0EtZSi6R2bq1oIATFyIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011, Timur Tabi wrote:
> 
> The ePAPR embedded hypervisor specification provides an API for "byte
> channels", which are serial-like virtual devices for sending and receiving
> streams of bytes.

Why is this using a full tty driver instead of the hvc framework that most
other hypervisor consoles use?

	Arnd
