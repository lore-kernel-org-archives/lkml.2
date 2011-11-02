Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1KBVDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 17:03:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63030 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1KBVDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 17:03:04 -0400
MIME-Version: 1.0
Date: Wed, 2 Nov 2011 17:03:03 -0400
Message-ID: <CALKntY3zkAHc92_6Sk2Mg06J6N1RCj38O7AQk0a5d6pCtivD-Q@mail.gmail.com>
Subject: Undefined Instruction
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an application contains an undefined instruction to the processor (
x86 in particular ) how does the operating system handle it. does the
operating system just kill the process, or it will throw signals,
trying to recover from it ?

Thanks

Xin
