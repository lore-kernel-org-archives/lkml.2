Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2F2Knf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:43:35 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42104 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2F2Kne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:43:34 -0400
MIME-Version: 1.0
Date: Fri, 29 Jun 2012 12:43:32 +0200
Message-ID: <CAN+9=X-Y4wdBOjZYAXN0hmMappmHQGo=P3OcZeJ-62L5VJWVOg@mail.gmail.com>
Subject: IPsec timing measurements of kernel functions, influence of periodic tasks
From: Bernd Hirschler <bernd.hirschler@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am doing IPsec timing measurements to find out the packet delay it
introduces. For measuring the elapsed time rdtsc is used and the
values are gathered in several kernel functions. Kernel source was
modified by me and is based on 2.6.26. The autocorellation of the
measurement data shows periodic tasks, e.g., approximately every two
minutes.

Is a list of periodically performed tasks available? Already looked at
/proc/timer_stats, /proc/timer_list and /proc/sys/vm/*
Does anybody now tasks that get executed in that frequency?

The only option (i can think of) is to use kprobe on all functions and
try to find the tasks manually. However, I think there has to be a
more efficient way to perform this taks.

Please add me in CC!

--
Kind regards,
Bernd
