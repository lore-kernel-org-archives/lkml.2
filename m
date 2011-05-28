Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab1E1Pwn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:52:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43703 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1E1Pwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KxIX5oZGPH7bt7Tcfxe9unTsMd8tsjWHZ244wreWaw3Vy22/EQqVgAQHxRM74GkCNA
         L294OP9nMAsYWk9MHPv8/ZgsODqOTxxYgZJpq877vXFW1ThVzIbcdyiqMH3UueObdVML
         yBVeL/YOwuFcoDOEMe/WCEgRsfND4h8r2kOes=
MIME-Version: 1.0
Date: Sat, 28 May 2011 08:52:41 -0700
Message-ID: <BANLkTikuz1c9dCB65PqrHCXMSt+7_cS11w@mail.gmail.com>
Subject: Can someone explain s_xattr field in the superblock?
From: Sam Gandhi <samgandhi9@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have seen some file systems like jffs2/ext4 etc setup the s_xattr
field in the superblock structure.
But there are files systems that  do not initialize s_xattr field in
the superblock.

Can someone kindly explain what functionality  does s_xattr on super
block provides? What kinds of things file system wouldn't be able to
do if the superblock doesn't have this initialized?

Thanks.
-Sam
