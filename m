Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab3AFRxo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 12:53:44 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:54161 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab3AFRxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 12:53:42 -0500
MIME-Version: 1.0
In-Reply-To: <CAN_LGv2RVeE88iJTeeYrin+_gKb9Pcg4feBcbKgEGEy8YmpCpQ@mail.gmail.com>
References: <CAN_LGv2RVeE88iJTeeYrin+_gKb9Pcg4feBcbKgEGEy8YmpCpQ@mail.gmail.com>
Date: Sun, 6 Jan 2013 23:53:41 +0600
Message-ID: <CAN_LGv1L3RLrwnzdN7oYM8ewjRoptGuK-4wQ9+oXWd+NK9CgNw@mail.gmail.com>
Subject: Re: linux-3.7.1: disable and reenable NMI watchdog => panic
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

As illustrated by the screen photo [1] (sorry for bad quality),
disabling and then reenabling the NMI watchdog panics the kernel
(3.7.1). This is reproducible in qemu-kvm as well, but I could not get
the nice panic message to pop up there (most of the time, the real
machine just locks up, too). This bug is rather important, as
laptop-mode-tools, by default, try to reenable this NMI watchdog when
AC power appears, and this is how I caught the bug the first time.

[1] http://postimage.org/image/mjjifj1ip/

-- 
Alexander E. Patrakov
