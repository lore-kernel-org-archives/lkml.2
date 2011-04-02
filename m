Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab1DBS57 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 14:57:59 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53830 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567Ab1DBS56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 14:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=wtEJE7KjbMjqGNIbH3VSBcmGcDVV8SB00DEuSmU/NhuqFUUQKXMDBuq2GtguN4JB+Y
         zvo9UfZlnyFYSnZaaSAOnoeFfz6oTgsQo8VApRrkQy18PkDR9+zqs3G6RXEe7ZOTizR8
         daCzpJ/dHoVs+yLt/rz9G1K7zqeufw56QG4Nk=
MIME-Version: 1.0
Date: Sat, 2 Apr 2011 13:57:57 -0500
Message-ID: <AANLkTi=Vg5Abygpj_BQp=vQOPPTrbTyGjhO=GH9LRkMA@mail.gmail.com>
Subject: Documentation/Changes correction?
From: Someone Something <fordhaivat@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, Documentation/Changes says that grub 0.93, don't you guys
think we should also mention lilo? I know the trend is going towards
grub, but, lilo, for many of us (notably slackware users), is still
going strong. If the community says yes, it would be nice if I could
have the privilege to submit the patch myself (it'll be my first
patch!).
