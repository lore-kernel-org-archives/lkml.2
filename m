Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1HLO2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 10:28:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49066 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1HLO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 10:28:32 -0400
MIME-Version: 1.0
Date: Fri, 12 Aug 2011 16:28:31 +0200
Message-ID: <CACTFLANCxbACB5yNZvHOmuZDfpuDN1TkABV2BgmvJwQ5RBVKYw@mail.gmail.com>
Subject: git.kernel.org has issues accessing torvalds/linux.git
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone else see this?

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Cloning into linux...
fatal: The remote end hung up unexpectedly
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
Cloning into linux-2.6...
fatal: The remote end hung up unexpectedly

However, other repositories seem to work fine:

$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
Cloning into sound-2.6...
remote: Counting objects: ...
(works)
