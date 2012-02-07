Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2BGKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 05:25:28 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43025 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab2BGKZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 05:25:26 -0500
MIME-Version: 1.0
Date: Tue, 7 Feb 2012 15:55:25 +0530
Message-ID: <CADa7JjUbuY0qKiVdpS5VJk+5z5reZjBs0zcMCZ4SKnMSLai+pA@mail.gmail.com>
Subject: CPU processing time between using TCP and UDP
From: Srinidhi M <srinidhi.m26@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We have an application which uses the TCP/UDP packets. The packet
processing time between application and session layers is same for TCP
as well as UDP. However, there is a packet processing time difference
after sending it to layer 4 either TCP or UDP. Generally, we are
calling the socket() API for transmitting the packet. We are seeing
the difference in Linux Network Stack.

Could you please let me know, which module in TCP/IP is consuming more
time than UDP? How can we reduce packet processing time when sending
through TCP stack? Please let me know your thoughts.

Please let me know, the appropriate mailing list name for this type of
questions.

Thanks in advance.

Regards,
Srinidhi M.
