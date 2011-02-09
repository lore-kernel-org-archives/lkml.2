Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1BIRh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:37:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56437 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab1BIRh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:37:58 -0500
Date: Wed, 9 Feb 2011 09:36:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc4 (other bugs)
Message-Id: <20110209093656.2b23b80b.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D52D0C0.0133:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are also bugs or other oopses etc. with ipmi, x25 (rmmod hangs system),
and (usb gadget) g_audio, but I don't have logs for them yet...
Someone else could do those.

Oh, and ext4, which was reported on the ext4 mailing list.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
