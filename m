Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2FNVFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:05:54 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45655 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2FNVFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:05:53 -0400
MIME-Version: 1.0
In-Reply-To: <20120614160129.GA3433@redhat.com>
References: <CANaxB-xyBw+O9h7OrFRNM93+Gp+GX63C-OgOZ2ZK2QbKMDBJ7g@mail.gmail.com>
	<20120614160129.GA3433@redhat.com>
Date: Fri, 15 Jun 2012 01:05:51 +0400
Message-ID: <CANaxB-yO0Sdt_JTHDHJCaT6OHMgBBg09Qc+6_SHWMeeXHXDGWw@mail.gmail.com>
Subject: Re: general protection fault on finalizing task
From: Andrew Wagin <avagin@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Could you please re-test with these
>
>        http://marc.info/?l=linux-mm-commits&m=133962463616232
>        http://marc.info/?l=linux-mm-commits&m=133962463616231
>
> patches applied?

Yes. They fixed the bug. Thanks.
