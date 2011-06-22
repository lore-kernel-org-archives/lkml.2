Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab1FVKuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:50:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39850 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1FVKuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:50:50 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.119.47]
In-Reply-To: <BANLkTimAf9EqSX-yHh_0RPaeewndOyNUYA@mail.gmail.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-3-git-send-email-ohad@wizery.com> <BANLkTimAf9EqSX-yHh_0RPaeewndOyNUYA@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 22 Jun 2011 13:50:28 +0300
Message-ID: <BANLkTin6eFqQLb-Wkq=Q7rbm7GCjKtz8zg@mail.gmail.com>
Subject: Re: [RFC 2/8] remoteproc: add omap implementation
To: Will Newton <will.newton@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 1:05 PM, Will Newton <will.newton@gmail.com> wrote:
> On Tue, Jun 21, 2011 at 8:18 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>
>> +/* bootaddr isn't needed for the dual M3's */
>> +static inline int omap_rproc_start(struct rproc *rproc, u64 bootaddr)
>
>> +static inline int omap_rproc_stop(struct rproc *rproc)
>
> These two functions don't need to be inline as far as I can see.

They definitely don't need to. Thanks !
