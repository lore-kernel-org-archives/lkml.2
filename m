Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389Ab0FRSMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 14:12:33 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54969 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab0FRSMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 14:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=KQy//mmxQO+FYadqcS4QpL0GB7z9HvQjmWdU8JPA6zZ4JrYbuLG2THjcWxqA7Asff6
         ZmoQHt2JzuM0WVT7sC1yg681MXxqzpJFx404J+ItxdFnrVI9VRdC/a/UmTfrzPK1aK0F
         87j3YuM9H13Fs8tVfy7mSPxjnNXmmQzqQHwMU=
MIME-Version: 1.0
Date: Fri, 18 Jun 2010 14:12:22 -0400
Message-ID: <AANLkTilWguh4IrDHVgtTxjoiAeSy23SK_M1dWapgvSDt@mail.gmail.com>
Subject: idea about internal fragmentation in Btrfs
From: Zhihui Zhang <zzhsuny@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wish Btrfs well, so I would venture an idea for this specific case
mentioned by Edward Shishkin today.

Everyone knows that B-tree has internal and leaf nodes.  Can we make
the root as the leaf?  In other words, if you
create a 2K file, the B-tree will have only one node, which is both
the root and the leaf. Of course, you need some flag to
say this is a "degenerated" form of B-tree. Please cc me if you want
my response.

thanks,

-Zhihui
