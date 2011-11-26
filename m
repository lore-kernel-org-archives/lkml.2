Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1KZJuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 04:50:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43279 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1KZJuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 04:50:10 -0500
MIME-Version: 1.0
From: Rahul Bedarkar <rpal143@gmail.com>
Date: Sat, 26 Nov 2011 15:19:48 +0530
Message-ID: <CA+NV+VmNxbQhfr01kGrwy+BGPr0dVi+zmGwpev1rtcoLy8p7bA@mail.gmail.com>
Subject: Regarding swapping active and expired array in CFS in sched.c
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    I saw comment in sched.c that "hybrid priority-list and
round-robin design with
    an array-switch method of distributing timeslices and per-CPU runqueues".

    But I am not seeing swapping of active and expired to get new
timeslices. Is algorithm
    changed or am I doing mistakes ?.  :( Please help me out.


Regards,
Rahul Bedarkar
