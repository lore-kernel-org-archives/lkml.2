Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760571Ab2FUVyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:54:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44205 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760463Ab2FUVyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:54:23 -0400
MIME-Version: 1.0
Date: Thu, 21 Jun 2012 23:54:21 +0200
Message-ID: <CAFLxGvyvbr1pTP9Qy+bJhLXnm3OkutqW0QGf8fRi6Dj4-_qUnw@mail.gmail.com>
Subject: UBI fastmap updates (was: no subject)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        artem.bityutskiy@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 11:49 PM, Richard Weinberger <richard@nod.at> wrote:
> This is the next round of UBI fastmap updates.
>
> The highlights are:
>        - New self checks and a better fall back to scanning mechanism
>        - The attaching by fastmap code got simplified
>        - invalidate_fastmap() now really invalidates the fastmap B-)
>        - Minor fixes
>
> If you want to test fastmap you can use my git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v12

Sorry, I've killed the subject line. :-\

-- 
Thanks,
//richard
