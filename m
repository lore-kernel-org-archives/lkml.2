Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0H3Rfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:35:38 -0400
Received: from claw.goop.org ([74.207.240.146]:53263 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab0H3Rfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:35:37 -0400
Message-ID: <4C7BEBE7.8060502@goop.org>
Date: Mon, 30 Aug 2010 10:35:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Hank Janssen <hjanssen@microsoft.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>
Subject: Re: hv block drivers
References: <201008301643.42253.arnd@arndb.de> <4C7BD9A6.1090108@goop.org> <201008301908.51521.arnd@arndb.de> <8AFC7968D54FB448A30D8F38F259C56224274727@TK5EX14MBXC118.redmond.corp.microsoft.com>
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C56224274727@TK5EX14MBXC118.redmond.corp.microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 08/30/2010 10:31 AM, Hank Janssen wrote:
> For a more general question, When/if we make it out of staging, where should these drivers live?
>
> 	drivers/hyper-v or drivers/scsi and drivers/ide.
>
> Is there a standard that is being followed?

If they're not actually scsi/ide subsystem drivers, then drivers/block
would seem like the best place (and drivers/ide is truly ancient stuff,
I think).

    J
