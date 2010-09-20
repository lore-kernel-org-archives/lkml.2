Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab0ITNaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 09:30:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64038 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0ITNaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 09:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Nv8/Ax58ils4HF1Ek8YSjrYHW97tchk48GDlPqSQyJj0YjTgaCV8aFMrYXc37W3/Rs
         gvEwXMNhMcm7M7SVtADWk246IFN+k3LyO6Cq8KLhd3JxlgJnODbJsuV+TKUhuUfbhdeO
         9DFTADG3/Ygil3IzZJsX6UJd+mLcIPRf9X3uw=
MIME-Version: 1.0
Date: Mon, 20 Sep 2010 19:00:21 +0530
Message-ID: <AANLkTikUZeDb5F760UF5y2=uei=rzhcV78pmqxK_C_cw@mail.gmail.com>
Subject: syscall should be in same order?
From: Jack Daniel <wanders.thirst@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is it mandatory that system call numbers defined in unistd.h match
with those in its counterpart *.S file? Will the wrong system call be
called if a mismatch exists?


Regards,
Jack
