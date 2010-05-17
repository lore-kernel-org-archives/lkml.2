Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab0EQIXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:23:31 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:45200 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab0EQIX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:23:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=IaQLvb7uC50W4WN9UjFtzuQos/F2xWkdBeAGHzL1sn9zgawFJBANzHjORhLisZgZSr
         i8h0O+L3vF7cv8ztD1TK7cY5PSBm27b4iFbp1B5/96/hysYwv/UoJU3tfOBWUzpzEPxK
         SBWAS51LL1rV37LaFeN7pVBqh0VzXtP6JW5CQ=
MIME-Version: 1.0
Date: Mon, 17 May 2010 10:23:28 +0200
Message-ID: <AANLkTimqzMn68nz1RmRRNGwcAO-5ox9Hka0LvhvipXdG@mail.gmail.com>
Subject: btrfs failed to delete reference
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While executing "rm -Rf dir" on an btrfs-device, I got the following
syslog-entry:
btrfs failed to delete reference to CalendarDateType.java, inode 27909
parent 25891

The filesystem was mounted with "compress", and I am running kernel-2.6.32.11.

Any idea what the problem could be? Should I file a bug?

Thanks, Clemens
