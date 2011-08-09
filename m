Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1HILnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 07:43:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:59469 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab1HILnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:43:51 -0400
Message-ID: <4E411D72.7000604@linutronix.de>
Date: Tue, 09 Aug 2011 13:43:46 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Chris Wright <chrisw@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio/gen-pci: don't enable interrupts in ISR
References: <20110804204606.GA19724@linutronix.de> <20110804210413.GA29222@redhat.com> <20110805191842.GA4224@linutronix.de> <20110808064050.GC5182@redhat.com>
In-Reply-To: <20110808064050.GC5182@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
>> It seems to me that you could drop this "user block" thing
>> since you never change anything outside of this command register and it
>> does not stop the race.
> 
> I don't think so: if we did, we would lose userspace modifications to
> other bits such as io enable, and there's no way to guess what their
> values should be.

How so?

Sebastian
