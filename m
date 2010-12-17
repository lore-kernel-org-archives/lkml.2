Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab0LQKmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 05:42:08 -0500
Received: from www.tglx.de ([62.245.132.106]:60933 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab0LQKmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 05:42:05 -0500
Date: Fri, 17 Dec 2010 11:41:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <4D0B3C11.4090307@siemens.com>
Message-ID: <alpine.LFD.2.00.1012171137430.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6> <4D0A75E3.3090900@web.de> <4D0B1CD9.5060601@web.de>
 <alpine.LFD.2.00.1012171116480.12146@localhost6.localdomain6> <4D0B3C11.4090307@siemens.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Jan Kiszka wrote:
> Am 17.12.2010 11:23, Thomas Gleixner wrote:
> > OTOH, if we have to disable anyway, then we could simply keep it
> > disabled across the installation of a new handler. That would make the
> > notification business go away, wouldn't it ?
> 
> No, the notification is still necessary in case the registered handler
> keeps the line off after returning from both hard and threaded handler.

And how should that happen? If it is in oneshot mode then the line is
reenabled when the thread handler returns.

Thanks,

	tglx

