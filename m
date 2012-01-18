Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab2ARPmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:42:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41729 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757897Ab2ARPmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:42:49 -0500
MIME-Version: 1.0
In-Reply-To: <4F16C24A.4050007@linux.vnet.ibm.com>
References: <201201172345.15010.rjw@sisk.pl>
	<201201180015.56510.rjw@sisk.pl>
	<4F16C24A.4050007@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 07:42:47 -0800
X-Google-Sender-Auth: vGtJKvT-WJZhOe4XpshU2L9NA54
Message-ID: <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related to unlock_system_sleep()
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        "pavel@ucw.cz" <pavel@ucw.cz>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 18, 2012 at 4:59 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> +       /*
> +        * Don't use freezer_count() because we don't want the
> +        * call to try_to_freeze() here.
> +        */

Please explain "why" here.

Thanks.

-- 
tejun
