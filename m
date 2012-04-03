Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2DCQFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:05:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37314 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751656Ab2DCQFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:05:40 -0400
Message-ID: <1333469136.26079.33.camel@joe2Laptop>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Date: Tue, 03 Apr 2012 09:05:36 -0700
In-Reply-To: <CAPXgP133MQX2u3H6imOR4FFR4TsHYc=f_yrAJfdd2sG-8bFrmA@mail.gmail.com>
References: <1333415903.860.0.camel@mop>
	 <1333420612.26079.6.camel@joe2Laptop>
	 <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
	 <1333424865.26079.9.camel@joe2Laptop>
	 <CAPXgP13fDRZtAvV651NPqQ2TgUEtb+MX1EhKhwirAgoiNOg5tQ@mail.gmail.com>
	 <1333463572.26079.31.camel@joe2Laptop>
	 <CAPXgP133MQX2u3H6imOR4FFR4TsHYc=f_yrAJfdd2sG-8bFrmA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 17:50 +0200, Kay Sievers wrote:
> I did not claim to address the problem of concurrent continuation line
> writers, and this patch has absolutely nothing to do with that
> problem. It _does_ fix encountered problems,

No it doesn't.  It fixes problems _you_ encounter
with an unpublished modification of the printk
subsystem.


