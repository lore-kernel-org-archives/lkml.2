Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab2GEMSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:18:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62903 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2GEMSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:18:37 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: sshtylyov@mvista.com, jgarzik@pobox.com
Subject: [PATCH v3 0/2] ata: MODE SELECT implementation
Date: Thu,  5 Jul 2012 14:18:19 +0200
Message-Id: <1341490701-15348-1-git-send-email-pbonzini@redhat.com>
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

