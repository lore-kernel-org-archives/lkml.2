Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0GVXNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:13:07 -0400
Received: from smtp-out.google.com ([74.125.121.35]:53172 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0GVXNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:13:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=l0aQHg8673EcpeORXJIeBo66WMh8hBgdsAUOI1RKbTR0RrWnGv+Lb8QyzV0MlVqFK
	qvnNnVJXPbSscqboYqwzw==
MIME-Version: 1.0
In-Reply-To: <20100722211958.GB1297@suse.de>
References: <20100722182638.GA12712@kroah.com>
	<AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
	<20100722183614.GA5443@suse.de>
	<AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
	<20100722185301.GA528@suse.de>
	<AANLkTik07hZot_x0p7xJuY8s4f8pGRd2Mn1+jYfHH2iq@mail.gmail.com>
	<20100722191200.GA5609@suse.de>
	<AANLkTi=8TTeGG3OTbP4zzNAe_rDaNNL8D0Yxp7DixohK@mail.gmail.com>
	<20100722211958.GB1297@suse.de>
Date: Thu, 22 Jul 2010 16:12:58 -0700
Message-ID: <AANLkTimwUC_ToxADRR9n5_KLFVHgL=ymMngXAyt+OboJ@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
From: Paul Menage <menage@google.com>
To: Greg KH <gregkh@suse.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 2:19 PM, Greg KH <gregkh@suse.de> wrote:
>
> Any suggestions from your side?
>

I'd probably go with Matt's suggestion of /var/run.

Paul
