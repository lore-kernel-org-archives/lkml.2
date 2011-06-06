Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab1FFPmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:42:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFPmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:42:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Mon, 6 Jun 2011 17:42:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: kumar.gala@freescale.com, benh@kernel.crashing.org, greg@kroah.com,
        akpm@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106031724.44957.arnd@arndb.de> <4DE8FD85.7000703@freescale.com>
In-Reply-To: <4DE8FD85.7000703@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061742.01974.arnd@arndb.de>
X-Provags-ID: V02:K0:QHCZYr+4MsS2imWCjqQZlqANB4aTfPu+vPSmFWgGqvX
 BxKRC9+tJlPbn9KZDn0vme/DNgA7ExNEAu+7HMeDjryYnnLMEi
 QTiozhIj8ByGs8MRWR65RVoE5hrIFT8zqiMsxDd9onaE+CSDj4
 Mi3i5PQm1k8ZilBl7txEDrdvQrdh0svrW7A4p+qbLSR8rgmto2
 yxuM4n2Vc4UO0HHZKWrfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011, Timur Tabi wrote:
> Arnd Bergmann wrote:
> >> > I don't think it's correct to think of a hypervisor as firmware, so I don't
> >> > think drivers/firmware is better.
> >> > 
> >> > I'm not sure that creating virt/fsl and putting the driver in there is a good
> >> > idea, because it will be the only driver in that directory.  Unlike KVM, this
> >> > driver is just a collection of front-ends to our hypervisor API.  The actual
> >> > hypervisor is completely separate.  That's why I put it in drivers/misc, because
> >> > it's just a single driver with a miscellaneous collection of interfaces.
> 
> > Ok, fair enough. If nobody has a strong preference any other way, just make it
> > drivers/firmware then.
> 
> Did you mean to say drivers/misc?

Sorry, I misread your first sentence above. I thought you said that you prefer
drivers/firmware over virt/fsl. drivers/misc is definitely the wrong
place for this, please choose a better one. Maybe drivers/virt/ ?

	Arnd
