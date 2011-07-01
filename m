Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1GAGTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 02:19:52 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:48464 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1GAGTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 02:19:51 -0400
Date: Fri, 1 Jul 2011 08:19:43 +0200
From: Marc Koschewski <marc@osknowledge.org>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: CONFIG_ACPI_PROC_EVENT disabled -> userspace not working (Was: Re:
 CONFIG_ACPI_PROCFS_POWER to be removed in 2.6.39)
Message-ID: <20110701061943.GA17184@marc.osknowledge.org>
References: <20110630213728.GA30291@marc.osknowledge.org>
 <BANLkTimk_yCCy+4hL6949nxPs5Qo4y1Qow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <BANLkTimk_yCCy+4hL6949nxPs5Qo4y1Qow@mail.gmail.com>
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.39-dezzy
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Américo Wang <xiyou.wangcong@gmail.com> [2011-07-01 08:55:23 +0800]:

I just disabled the 3 'deprecated' within ACPI and ACPI userspace is not working
any longer. I'm using Gentoo so I doubt my userspace is too old. acpid doesn't
somehow listen to events when CONFIG_ACPI_PROC_EVENT is not set:

"Say Y here to retain the old behaviour.  Say N if your
user-space is newer than kernel 2.6.23 (September 2007)."

> On Fri, Jul 1, 2011 at 5:37 AM, Marc Koschewski <marc@osknowledge.org> wrote:
> > Hey guys,
> >
> > CONFIG_ACPI_PROCFS_POWER is still there. Missed it or did you want it
> > to reside?
> 
> There was a patch to remove it,
> 
> https://patchwork.kernel.org/patch/654021/
> 
> Don't know why it is not merged.
> 
> 

-- 
Marc Koschewski
