Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0JNU6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:58:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59523 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab0JNU6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=f3RF1VKBTfIa3puP2f7rXz011FOmUExwMpXe1PQcPCO8ISVcg9YRytUvCFB7x606Js
         Jdi8hE9r/SdYW48SFdxgmTExLvvfWGYYCxHtz1OkV8SprazxQVycPfqScA75hrPzjJr+
         32gRJ0bRdYdKRam07NdCsGpytMX6FAR8tMS3w=
MIME-Version: 1.0
Date: Thu, 14 Oct 2010 13:58:46 -0700
Message-ID: <AANLkTim2_St6Z9dLHaFxfcufM7gf=B_9ouYZWCb5M9KL@mail.gmail.com>
Subject: commit 0eead9ab breaks ia64 build
From: Tony Luck <tony.luck@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just pulled Linus latest and get these errors on ia64 build:

In file included from arch/ia64/kernel/elfcore.c:2:
include/linux/coredump.h: In function ‘dump_write’:
include/linux/coredump.h:14: error: implicit declaration of function ‘access_ok’
include/linux/coredump.h:14: error: ‘VERIFY_READ’ undeclared (first
use in this function)

I guess I have to start juggling some #includes ... anyone else have problems?

-Tony
