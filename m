Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0DOGWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 02:22:16 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41846 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab0DOGWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 02:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ZwJ3/P22ZrdQEZMoc9+oYgT4FHbhlzLnDbbDKx3DNaoZ0cihcd9qB3wZ6AOKuyuPHg
         2fe8CuJhblxBH6SBXI6DOd9KKcLEkb3SM+l+tSok+Aan63ZpBruGFG/Es/PTcpH+xBaG
         9tHHy1DWfjjivr+rek9id/HkCnX6d5qNaZxZk=
MIME-Version: 1.0
Date: Thu, 15 Apr 2010 11:52:11 +0530
Message-ID: <x2nc27429821004142322i3ce6756dib9c1a3f86000c5f5@mail.gmail.com>
Subject: [Question] integrating KDB with linux kernel
From: santosh <santosh.iitg@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How to integrate KDB with linux-kernel ??

What I did was as follow:

1.   Used  linux-2.6.21.7.tar.gz

 2.  Downloaded corresponding kdb  from "oss.sgi" site

    kdb-v4.4-2.6.21-common-3.bz2


   kdb-v4.4-2.6.21-i386-3.bz2



3.  build the kernel by enabling CONFIG_KDB and CONFIG_FRAME_POINTER as
described in "oss.sgi"

4.  installed the kernel and rebooted the system

5. When the system comes up, I check the kdb status

cat /proc/sys/kernel/kdb
// screen :
1

I logged in as root then invoke the kdb by press Pause on keyboard, but the
kdb
don't invoke. The system hangs  and two leds Caps Lock and Scroll Lock are
blinking. I had to do hard reboot .

.

please help me to fix this problem

regards
santosh
