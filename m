Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab2DYLDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:03:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49024 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758174Ab2DYLDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:03:12 -0400
MIME-Version: 1.0
Date: Wed, 25 Apr 2012 13:03:11 +0200
Message-ID: <CAOFJUkhi6NoECFGcz=rq8-uVXFc90V4SuH=A1+sWdvYDDhO8Ow@mail.gmail.com>
Subject: many rx packets dropped since 2.6.37
From: Chris <xchris89x@googlemail.com>
To: eric.dumazet@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There is a bug since 2.6.37 with dropped rx packets in virtual
environments (like kvm) and bonded network interfaces.

References:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/890475
https://bugzilla.redhat.com/show_bug.cgi?id=709551

This change has led to:
commit caf586e5f23cebb2a68cbaf288d59dbbf2d74052
Author: Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu Sep 30 21:06:55 2010 +0000

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=caf586e5f23cebb2a68cbaf288d59dbbf2d74052
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8990f468a

Would it be possible to remove this patch?

--
Chris
