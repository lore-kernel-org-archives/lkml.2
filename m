Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0C0HU1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 03:20:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63855 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab0C0HU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 03:20:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=tdwfxl7k07LIHS5+wozeGM3vmkIs+bHwR/eYzUV15oEqxd2Yc4HytgtelrEUFEq97M
         OcPrXLAvjfLQy4bNBlhHAmdvgD0jBo1LzJvo5wJJAuDYvaByylIsedsndwQTfwiHrf6u
         cZ3r+R3KRf4q1xpMKR1fHcR2OocsO+SE7xAEA=
MIME-Version: 1.0
Date: Sat, 27 Mar 2010 16:20:25 +0900
Message-ID: <8d2eb1f1003270020j12c6e519y40ce2203d378ad19@mail.gmail.com>
Subject: Status of a patch to export built-in kernel module info to sysfs
From: Yangkook Kim <yangkookkim@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: open-iscsi <open-iscsi@googlegroups.com>,
       Yangkook Kim <yangkookkim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, lkml list.

I'm from open-iscsi mailing list and want to know if somebody
already worked on a patch to export module information of
scsi_transport_iscsi module to sysfs when it is compiled
and built in kernel.

Digging through open-iscsi and lkml list, I found some discussions
about this issue at

http://groups.google.com/group/open-iscsi/browse_thread/thread/5d0fd37e7d6a606c/d42284704f3bdf95?lnk=gst&q=Rusty#d42284704f3bdf95

It looks like someone already made a patch but, can't find the one.

So, if you have any ideas about where I can find the patch, please
point it to me. Otherwise, I will make the one by myself.

Please include yangkookkim@gmail.com or open-iscsi@googlegroups.com
at CC in reply since I am not subscribing lkml list.

Thanks,

Kim
