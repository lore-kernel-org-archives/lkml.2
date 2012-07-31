Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2GaQj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:39:28 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:21600 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755662Ab2GaQj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:39:26 -0400
X-IronPort-AV: E=Sophos;i="4.77,688,1336341600"; 
   d="scan'208";a="168700818"
From: Damien Cassou <damien.cassou@lifl.fr>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] use devm_ functions
Date: Tue, 31 Jul 2012 18:39:17 +0200
Message-Id: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce devm_ functions in some video drivers.

