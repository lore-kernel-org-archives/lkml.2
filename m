Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1JVCML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 22:12:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36459 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1JVCMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 22:12:09 -0400
MIME-Version: 1.0
Date: Sat, 22 Oct 2011 00:12:07 -0200
Message-ID: <CAAiDW_RfbuWt6C3ixe1gM5FLTJZ7ekpGsaSMgVnt+bSy1mBUBg@mail.gmail.com>
Subject: Page Faults
From: Artur Baruchi <mail.baruchi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys.

I would like to create a module (probably unsig kprobe or jproble) to
separate some kinds of page faults. For example, suppose that during
10min my system experienced a total of 100 page faults. This module
should show me that, 10 page faults happened in cache, 30 page faults
happened in kernel pages, and so on...
My question is... which function should I probe to accomplish this?

Thanks in advance.

Att.
Artur Baruchi
