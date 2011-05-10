Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab1EJKmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:42:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60202 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1EJKmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=x/Hik/Pz3baqB/jTNTRShK/J15ce0xy8rsdtdcEavLXykVecqjflfyNnZLuQc6x+Sr
         +e8YJGw/rxdqzFSbO9Xaqt7m9jCIvGm27dxAC7zF5kowxMeUK+akC/uAlQN6J0YnZXGz
         H+G8JboHSuBLBKJoLtaiU3FRkmsMfZgQp6aR0=
MIME-Version: 1.0
From: Amirali Shambayati <amirali.shambayati@gmail.com>
Date: Tue, 10 May 2011 15:11:50 +0430
Message-ID: <BANLkTimS++GWcNSBNqwZ=cUtQwX1wdKzUQ@mail.gmail.com>
Subject: how to debug kernel in qemu using ubuntu image
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I'm using linux-0.2.img image(which is a light linux image) to debug
kernel using Qemu. I'm working on IO schedulers' optimization. As Qemu
boots kernel, IO scheduler sends read requests to disk. Also by
entering commands such as 'ls', it sends read requests. I'm looking
for a way to send write requests. Thus I thought that using a
benchmark which sends both read and write requests, is suitable, but
as linux-0.2.img is a very simple and light image, it is almost
impossible to setup heavy benchmarks on it. So I want to use an ubuntu
image instead. But I don't know where I should see kernel printks.

Thanks in advance
Regards,
-- 
Amirali Shambayati
Bachelor Student
Computer Engineering Department
Sharif University of Technology
Tehran, Iran
