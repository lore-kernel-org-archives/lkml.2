Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1FMOOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:14:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34831 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab1FMOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:14:29 -0400
MIME-Version: 1.0
X-Originating-IP: [78.21.59.235]
Date: Mon, 13 Jun 2011 16:14:27 +0200
X-Google-Sender-Auth: fDEPtFh0IwmcTy_GVyBAXDCvPdU
Message-ID: <BANLkTik3bBQqqzPgY1pGax3ZsnNSYR=9=A@mail.gmail.com>
Subject: [2.6.39.1] disable framebuffer console
From: Jan De Luyck <mailinglists+linuxkernel_20080830@kcore.org>
To: linux-kernel@vger.kernel.org
Cc: mailinglists+linuxkernel_20080830@kcore.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was wondering if there is an easy way to disable the framebuffer
console on 2.6.39.1? This seems to get auto-selected, and I really
don't want it.

Reason: I have to video cards (driven by the radeon driver, in KMS
mode) in my pc, and the machine is setup as a dualseat - two
screens/mice/keyboards, and two X servers running.
Unfortunately when i enable the framebuffer console, any ALT+Fx
keypresses will cause the primary screen to switch to the console, and
not give me
a way back to the X server.

On 2.6.37 (which I still am running now) this is no issue.

Thanks for any pointers,

Kind regards

Jan

(please CC me on answers, I'm no longer subscribed to the LKML)
