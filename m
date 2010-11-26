Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0KZHTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:19:12 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51589 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0KZHTK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:19:10 -0500
MIME-Version: 1.0
In-Reply-To: <20101126045912.GC6598@lixom.net>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101126045912.GC6598@lixom.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 26 Nov 2010 00:18:49 -0700
X-Google-Sender-Auth: egVtOpv69NAG-Wj7cZQ2I3fBn5o
Message-ID: <AANLkTimkovvHzgdnGtGpTH1pz8QLi9K0-rcWVHCdMJbu@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
To: Olof Johansson <olof@lixom.net>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hari Kanigeri <h-kanigeri2@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        akpm@linux-foundation.org, Suman Anna <s-anna@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 9:59 PM, Olof Johansson <olof@lixom.net> wrote:
> On Tue, Nov 23, 2010 at 05:38:57PM +0200, Ohad Ben-Cohen wrote:
>> +#define pr_fmt(fmt)    "%s: " fmt, __func__
>
> Not used.

pr_fmt() is a magic #define that changes the behaviour of the pr_*()
macros.  See include/linux/kernel.h

g.
