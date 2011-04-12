Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1DLMpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 08:45:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34697 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1DLMpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 08:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=sMSyxpyx1Kz/IHn40qlPlDEknmET6VXMMfXNar4P2n+kaN0o59NboWT+5P9I3U3kZk
         eAx5fVQu8W8fv6Li/AMDgxe6eSkNw5D5N3DdTt5MjlYQ/h/SjCk0JtNt5m/+1ihH+MEH
         KilClrITHH9yeIfDHSep43Y8fsOFVPX78UlBY=
MIME-Version: 1.0
Date: Tue, 12 Apr 2011 14:45:44 +0200
Message-ID: <BANLkTimAY2YTFE1_uFJg=XVtV_ww2jdJrw@mail.gmail.com>
Subject: regression - slow git rebase performance with 2.6.39-rcX kernel
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm noticing quite slower speed of my git rebase commands on my git
tree compared with 2.6.38 kernel.
I've  T61 with SSD disc drive, ext4 fs, and by default deadline disk
io scheduler
The counter showing the number of 'rebased' patches on top of master
is going much slower.
When I boot 2.6.38 kernel it's much faster.

Is it a known problem - or do I need to make a bisect ?

Zdenek
