Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0JYIl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 04:41:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43172 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0JYIl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 04:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=o4jYFRd+pHpkUrKO30nxptBQT+SXyG+Zrgv1BBPKptGT31vylDSyClabB9uEGzcaqO
         KwWGfC7xuCZaKT6js7jc61rMCwL0V9H8CEN8G8wKC7HDrGeM6Zg7h7evQleMZECAepq8
         jUK3fWefo6fRqR4/A15bc3AInYy95U3+OBx9I=
MIME-Version: 1.0
Date: Mon, 25 Oct 2010 09:41:24 +0100
Message-ID: <AANLkTinX=hNOWsJFxvBEe63My6sETgFzH4qoPCbbB2rX@mail.gmail.com>
Subject: ext4 file system size limit
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lkml,

(please cc as not subscribed)

The ext4 documentation says the current file system size limit is
16TB. I currently have an fs of 6TB which is working fine, but I'm
planning to expand it.

Are there any known bugs with large file systems, or is it safe for me
to proceed and extent the fs? (up to 16TB)

Regards,
// Mathias
