Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0JNMbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:31:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52805 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0JNMbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:31:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=s3+kc87BMXI6YaX4biRSNsI2AxZYIxfCtVfX9LI1kp0kt/Lb6q0z+Am6rWLC3aYklO
         MuMxo/snNTE2nMtIf17tFstuwlaFphmuqMvFfavChrZ60itQJXjI+85UJ1B4OPgs4oan
         u/1uMO+nY7MsI+8ZyJuozWn0cPSGwq/iaF7rQ=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5]staging:ft1000:various code cleanup. 
Date: Thu, 14 Oct 2010 11:40:55 +0200
Message-Id: <1287049260-11988-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following series of patches try to fix code according kernel CodinStyle.
