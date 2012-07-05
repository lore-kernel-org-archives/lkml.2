Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2GEJkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 05:40:55 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41897 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab2GEJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 05:40:52 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH v2 0/2] ata: MODE SELECT implementation
Date: Thu,  5 Jul 2012 11:40:33 +0200
Message-Id: <1341481235-12708-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a revised version of the MODE SELECT implementation from yesterday,
augmented with support for changeable parameter requests in MODE SENSE.

Paolo Bonzini (2):
  ata: support MODE SENSE request for changeable parameters
  ata: implement MODE SELECT command

 drivers/ata/libata-scsi.c |  242 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 221 insertions(+), 21 deletions(-)

