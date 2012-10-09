Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab2JIEBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:01:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49523 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JIEBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:01:20 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] firmware loader: misc changes
Date: Tue,  9 Oct 2012 12:01:00 +0800
Message-Id: <1349755264-23876-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first two are fixes' patch, the 3rd one is to enable
caching firmware for direct loading, and the last one is
a cleanup patch.

 drivers/base/firmware_class.c |  266 +++++++++++++++++++++++------------------
 1 file changed, 151 insertions(+), 115 deletions(-)


Thanks,
--
Ming Lei


