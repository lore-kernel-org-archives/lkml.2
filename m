Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0KASld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:41:33 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45912 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab0KASlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jkqXdtqc6wHLZrckvQ6kitMipmizywc2wq17krMB54oxcogVI88ZXQpX8BVJ5h1QGa
         bhWPo54dlQ9Yl+sEWmQaGGJQOnHXWG1WpH5uW1g4VeN8rLyh5calpc0/q36ID3CAZ0lh
         AjbZcN6OVWDEjhYcNh+nV7KP//m0cBsNda3FM=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/29] Staging: Add yaffs2 filesystem 
Date: Mon,  1 Nov 2010 14:40:48 -0400
Message-Id: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patch sets puts the yaffs2 filesystem in the staging directory.
It is all based on Charles git tree(http://github.com/cdhmanning/linux-yaffs-integration/).
Everything is compile tested and it builds.

This only the inital support and I will be sending more cleanup patches.

Greg can you add the patch set into your staging-next tree.
Also, It doesn't affect anything other than itself.

Thanks,

Tracey Dent
