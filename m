Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0CPUJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:09:11 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41172 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab0CPUJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WL+jlEUMvsnP5qSW3yHfrQDwNRwaDpKaFTKNlbjOZLF2qwz3BGL2OLH1fP1iy6ylrh
         2c0YWX/JZIvS0Kz+TCPoYm5h2Eatf0WauI5v0zQ2OdfRfX28wEYBb9806qPTbeSREJaQ
         xhXtKDjmKZM4o/X+dOw/3klaarbwMYxSPYFlM=
MIME-Version: 1.0
Date: Tue, 16 Mar 2010 21:07:27 +0100
Message-ID: <1cf6d37d1003161307n53cb9d5aj6f87d0819f537c09@mail.gmail.com>
Subject: no kernel events
From: kees schoenmakers <kslinux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm puzzled by a machine where "udevadm monitor --kernel" reports
nothing when items are connected/disconnected to USB. Only when I
disconnect the USB-keyboard I get one disconnect event and nothing
after. Reconnecting the keyboard leaves it unrecognized and
dis-functional.

Kees
