Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0C0RTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 13:19:08 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:48822 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0C0RTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 13:19:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=jS4Ts8GfpdFdo1iijzjdsO07h8biugkL9ote6Y+Kkt8yotUNE6G1ejrUR5jhhIXVXh
         ETVokE+s/srjHKb5Uji8Rc0iwKZU2Y+coDAulAAYo4zXXa8Ha/5M1JInmzeiebf6Hfpf
         PgEu0SftsbWdm6BB4yzginn5Z/jik4QFd753k=
Date: Sat, 27 Mar 2010 14:21:00 -0400
From: Michael Gilbert <michael.s.gilbert@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: CVE-2009-4537
Message-Id: <20100327142100.38d21565.michael.s.gilbert@gmail.com>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CVE-2009-4537 has been disclosed without any upstream activity for a
while now. Discussion about the issue dried up in January [0], and a
patch had been proposed [1], but no arguments were seen either for or
against it. Note that redhat has already shipped that in their various
kernel security updates.  Would it make sense to merge those changes
officially?

Best wishes,
Mike

[0] http://marc.info/?t=126202986900002&r=1&w=2
[1] http://marc.info/?l=linux-netdev&m=126210110408898&w=2
