Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab2ARIyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 03:54:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab2ARIyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 03:54:13 -0500
Message-ID: <4F16882D.10403@redhat.com>
Date: Wed, 18 Jan 2012 09:51:57 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Jones <drjones@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, holt@sgi.com, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, takata@linux-m32r.org,
        geert@linux-m68k.org, yasutake.koichi@jp.panasonic.com,
        jonas@southpole.se, kyle@mcmartin.ca, deller@gmx.de,
        jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
References: <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com> <201201120918.53026.arnd@arndb.de> <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com> <20120113085125.GA2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com> <20120113122202.GB2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com> <4F1442C5.70500@redhat.com> <alpine.DEB.2.00.1201161530170.16270@chino.kir.corp.google.com> <20120117144644.GC3188@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201171246280.2595@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1201171246280.2595@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 09:54 PM, David Rientjes wrote:

>>>> For instance, Why would CONFIG_EXPERT disable by default some HID devices?
>>>> I could understand why it is done for CONFIG_EMBEDDED, but certainly not
>>>> for an general EXPERT option.

> Um, no, HID_A4TECH is still only configurable for CONFIG_EXPERT with this 
> patch.  Jerome's premise is that this should be configurable for 
> CONFIG_EMBEDDED instead.  Please read what he wrote.

No it's not! I wrote that CONFIG_EXPERT should not change the default value.
I wrote nothing about that option being configurable or not.

Jerome
