Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab2JAPW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 11:22:28 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40857 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2JAPWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 11:22:24 -0400
MIME-Version: 1.0
Date: Mon, 1 Oct 2012 10:22:24 -0500
Message-ID: <CALKntY0GxEf2ktT9j46qWGZcKbsnEo91oc4QJfGGPz-NEqciEw@mail.gmail.com>
Subject: Context Switch Timer in Linux
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am wondering what timer is used for preemptive context switches in
linux 2.6+ x86 ? the PIT can fire at fixed interval, but it is not
per-cpu, i.e. can be handled by any CPU in the SMP system ? is Linux
using the APIC timer ?

Xin
