Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab1CNX5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:57:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47504 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab1CNX5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=euQVUr8HG10E/OW1umZ4Fgibi5FG0DIdnIXoPNtzvmqIVVvF1NtWIaCnv7b41BLBru
         wnYm1lS6Hg8sPDvn8zx72KPhm8pJ5nhvIiHaybgVrkbyXHEJiWpGjN18rKzRiw9evcy8
         Hp3xQA+rzsP5cm52Hz2c0KIUy2ciRt/jWQtwA=
MIME-Version: 1.0
Date: Mon, 14 Mar 2011 16:57:03 -0700
Message-ID: <AANLkTik5OR4qtgyzkqZ=ove5QBzLOjapiZi_3b6Byrsf@mail.gmail.com>
Subject: inconsistent order of notify_die and kgdb/debugger between powerpc
 and x86
From: Fredrick Prashanth John Berchmans <fredrickprashanth@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see in x86, the die chain notifiers are called first
before going to debugger but in powerpc its the
other way round.
Any reason for this inconsistency?
Because, I wanted to take some action before falling
to debugger in powerpc. Is there any way to do this?

Thanks,
Fredrick
