Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab0FMDcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 23:32:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43993 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab0FMDci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 23:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=tt+j1yJidujxpsqUCwR3BplyrZHOfckbfwdZ/u5GZVSdmockXjb/u4E8Wr7tLyLo/v
         ac6W0fnW5nIw05rH09aAYzed7ZzFG3VplXYZSyg/ML8J71aFvXN4h/k1NG4ZJDuxsQvY
         4L4ViHQKt2lykrOES4ExOKrxIfPfeWcMQX3iA=
MIME-Version: 1.0
In-Reply-To: <AANLkTilbMPLfd415EV32or8FZCM1sWi-RzeWtPAX95-o@mail.gmail.com>
References: <AANLkTimmhzbgddTZBoaSy4iXpjB4Gdy6zTab0EjCM1IK@mail.gmail.com>
	<AANLkTinwQ5tUDyHIObolQrd0jESH5PGEBKqwk6a_jHWK@mail.gmail.com>
	<AANLkTilbMPLfd415EV32or8FZCM1sWi-RzeWtPAX95-o@mail.gmail.com>
Date: Sat, 12 Jun 2010 23:32:36 -0400
Message-ID: <AANLkTilzq64CPECxFb77PEdjv1Pcj72622rmhPchz9L8@mail.gmail.com>
Subject: Help for a newbie
From: Someone Something <fordhaivat@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. I am pretty new to the world of kernel hacking and I have a few
questions. I have gotten myself a copy of Linux Kernel Development by
robert love and I am also reading parts of the source code. Here are
my current questions:

1) when you write userland apps, you usually include stuff like :
sys/types.h or errono.h where are all these defined in the linux
kernel because I would like to add a few syscalls of my own?

2) what are some bugs in the kernel that a beginner can fix?

3) is there any definitive guide to the kernel that you guys refer
most newbies to? (like Programming Perl for perl)?

4) Where's the linux kernel headed to next? What higher level features
(i.e. real features, not bug fixes) are going to implemented?

Thanks a bunch.

PS it'd be nice if you could CC me in the reply cause I don't think
I've registered properly
