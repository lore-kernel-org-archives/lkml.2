Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab0IXSZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:25:06 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41511 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab0IXSZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=IalhDIY6MPp1ozLtS3zwz/dr1LAOBA9Rt/EdrKx1DhK5u00//jcid6OT7QqN3i36Kh
         iTiTB8V3IfX6cOt1en/rQFwLf08V6MzLIq3cJxN/0RWtUvruj5R1h+uohSyoMZo/pYfY
         3bZdnymu615mFGY5kUlR10iS0ONSKNANhnvb4=
MIME-Version: 1.0
Date: Fri, 24 Sep 2010 14:25:00 -0400
Message-ID: <AANLkTikqf4rn6BP2gyQAuQrvt7EdFY8yfa+o8nfR9xWE@mail.gmail.com>
Subject: [PATCH 00/21] Staging: cleaned up makefiles cflag lines
From: T Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I changed every makefile in the staging directory to use the proper
ccflags-y option instead of EXTRA_CFLAGS. It builds also :) .

Thanks,
Tracey Dent
