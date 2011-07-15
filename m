Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1GOPbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:31:36 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:50399 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1GOPbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:31:34 -0400
MIME-Version: 1.0
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Fri, 15 Jul 2011 20:01:13 +0430
Message-ID: <CAC-yRPQL4Mdq9COjmATMmHym_+4PaC3cNxMECnwjCwakhuVGdg@mail.gmail.com>
Subject: How to recognize synchronous write requests
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As much as I know, type of an IO request can be realized by "DATA_DIR"
macro,but I wanted to know if it is possible to distinguish a read or
write is synchronous or asychronous.

I'm also using "blktrace" to extract requests dispatching to disk.
blktrace, determines synchrnous writes as "ws" and asynchronous writes
as "w".


Regards,

--
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
