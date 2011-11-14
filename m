Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab1KNTFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 14:05:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51945 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1KNTE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 14:04:59 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <ap@solarrain.com>
Subject: kernel 3.1.1 - cifs issue - ls: cannot access /cifs_mnt: Cannot allocate memory
Date: Mon, 14 Nov 2011 14:04:53 -0500
Message-ID: <00c001cca300$4b512b80$e1f38280$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcyjADb5PslHZzjoRx6UCZwFpJKuqA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CIFS "works" when I mount a Windows 7 host from my Linux host (3.1.1-x86_64)
but if I turn my machine off (Windows) and turn it back on, I get the
following error, is this normal? With NFS as a hardmount it just recovers,
with CIFS do I need to setup some sort of canary to unmount/remount?

 $ ls /cifs_mnt
ls: cannot access /cifs_mnt: Cannot allocate memory

Justin.


