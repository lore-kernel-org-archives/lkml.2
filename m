Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab0FONAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:00:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43306 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0FONAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:00:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=d/Og+m9q7QqLjfuAJhGmQQ2gX5V1XvFQsYYOMdr/gvel1+N7x85uf9+hkaKhdQzOK2
         pvys2fviWsECHI+qleBchln6JlnCGBywv9ay+luTAXr+qJNi3aAQZpzA6AQT3F0QMok5
         VeeuKc3UU8zZoYxpoLx4IYSKoK2F7dMMxBcjQ=
MIME-Version: 1.0
Date: Tue, 15 Jun 2010 15:00:40 +0200
Message-ID: <AANLkTikb3qA3HdyYBhTFpOSs-L4ayWfQQsIMTAY1898v@mail.gmail.com>
Subject: Red back tree and scheduler usage
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've a question regarding the usage of the red black tree done by the
scheduler. It seems that nodes with the same keys are allowed. However
I'm not sure if this is correct since rotations can break the binary
search tree property (key(left) < key(node) <= key(right)) in that
case. I'm not sure about the consequence though.

Could anybody confirm that this won't hurt ?

Thanks
-- 
Francis
