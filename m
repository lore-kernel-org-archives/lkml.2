Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2DWMMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:12:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60735 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2DWMMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:12:05 -0400
MIME-Version: 1.0
Date: Mon, 23 Apr 2012 17:42:04 +0530
Message-ID: <CAEMiV8t3o4Yi9uZTMgqYe8DJxX-fYxZ+UBVgd0HX_+eCYkJiTg@mail.gmail.com>
Subject: atl1e driver version 1.0.1.14 compilation on 3.x kernel
From: kapil jain <jainkkapil@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been trying to compile the atl1e driver version 1.0.1.14 on
Kernel 3.0.13  and I am getting the errors like
"struct net_device has no member named mc_list".

I checked in kernel sources linux/netdevice.h and found that this has
been deprecated in 3.x kernel however this member variable was present
in  2.6.11 kernel. Is there any way to patch the 3.x kernel to support
this?


--
___________________________________

Kapil Kumar Jain
