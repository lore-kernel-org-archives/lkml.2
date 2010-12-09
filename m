Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab0LIREp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:04:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25106 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab0LIREn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:04:43 -0500
Date: Thu, 9 Dec 2010 09:04:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: pavel@pavlinux.ru
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Sysctl interface to UNIX_INFLIGHT_TRIGGER_GC v.2
Message-Id: <20101209090428.6da9198c.randy.dunlap@oracle.com>
In-Reply-To: <4D00BE59.4090109@pavlinux.ru>
References: <4D004E42.7000807@pavlinux.ru>
	<20101209041310.GA5101@cr0.nay.redhat.com>
	<4D00BE59.4090109@pavlinux.ru>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Dec 2010 14:32:41 +0300 Pavel Vasilyev wrote:

> On 09.12.2010 07:13, Américo Wang wrote:
> > On Thu, Dec 09, 2010 at 06:34:26AM +0300, Pavel Vasilyev wrote:
> >> Maybe something to add in Documentation/kernel-parameters.txt ?
> > 
> > No, that is for boot parameters, you need to find something like
> > Documentation/networking/ip-sysctl.txt.
> > 
> 
> Thanks, added.

Now you need to send this to netdev@vger.kernel.org so that the netdev
people can review it.  Please.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
