Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab0I0FoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:44:05 -0400
Received: from crca.org.au ([74.207.252.120]:46620 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0I0FoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:44:04 -0400
X-Bogosity: Ham, spamicity=0.000082
From: Nigel Cunningham <nigel@tuxonice.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Swsusp patches applied to suspend-2.6#linux-next
Date: Mon, 27 Sep 2010 15:43:35 +1000
Message-Id: <1285566238-10966-1-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Rafael.

As discussed, here are the patches, modified to apply against your current
linux-next tree. A new first patch splits compression support out into its
own file, removing the need to have two versions of the load_image and
save_image routines, minimising the changes to the remainder of the
patches and making things cleaner than would otherwise be the case.

On my laptop, single-threaded compression actually slows writing down from
175MB/s to around 100-120MB/s (depending on how well the image compresses).
Reading speed improves from 218MB/s to around 245MB/s. I expect that
multithreaded writing would bring the writing (and reading) speeds back
up. It's on my swsusp to do list :)

Nigel

