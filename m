Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0GVXQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:16:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54247 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab0GVXQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:16:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=KYtx+a+UIG+3w/mQN0QPx+vxQJDUwrar+lGQE9DUOu2CNYCKO5qVJ6YwX4NvkBPxY
	hFPZ8MJoHLSiLkzAjG3vg==
MIME-Version: 1.0
In-Reply-To: <20100722231401.GA11538@suse.de>
References: <20100722182638.GA12712@kroah.com>
	<AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
	<20100722183614.GA5443@suse.de>
	<20100722193741.GA2688@redhat.com>
	<20100722211856.GA1297@suse.de>
	<AANLkTinFQtwrCC82T9KlKskDV8fn-zYgimyH2wguHkqY@mail.gmail.com>
	<20100722231401.GA11538@suse.de>
Date: Thu, 22 Jul 2010 16:16:13 -0700
Message-ID: <AANLkTin5uU-s-c5-jhRYhwpc=NDWCq3cDWQwAfOULq4d@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
From: Paul Menage <menage@google.com>
To: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Vivek Goyal <vgoyal@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Jan Safranek <jsafrane@redhat.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 4:14 PM, Greg KH <gregkh@suse.de> wrote:
>
> Ah, that makes it easier.  Paul and Vivek, any objection to this patch
> going in now?
>

Sounds reasonable.

Paul
