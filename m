Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2FCLNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 07:13:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39331 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab2FCLNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 07:13:13 -0400
MIME-Version: 1.0
Date: Sun, 3 Jun 2012 19:13:13 +0800
Message-ID: <CABexPfEq7cz-nng-gz9TQB=9pyeBFALsRDAPSDbM4HFe=cjxJA@mail.gmail.com>
Subject: [build error] building failed with sample kernel code enabled
From: Zhihua Che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    I was building kernel 3.4 with kernel sample code enabled on my
ubuntu-11.10.
    The steps I followed are:
    make O=xxx menuconfig
    make O=xxx -j16
    But it failed and complaint the following:

linux/samples/seccomp/bpf-fancy.c:13:27: fatal error: linux/seccomp.h:
No such file or
directory/home/harvey/open-projects/linux/samples/seccomp/bpf-direct.c:21:27:
fatal error: linux/seccomp.h: No such file or directory
compilation terminated.
