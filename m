Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab0FBXpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:45:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47353 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647Ab0FBXpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:45:49 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serge@hallyn.com>
Subject: [PATCH] EVM 
Date: Wed,  2 Jun 2010 19:45:07 -0400
Message-Id: <1275522308-7247-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previously posted EVM patches http://lkml.org/lkml/2010/4/21/372
have been rebased and are now available from
git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/security-next/#evm.
They apply with minor offsets to security-testing/#next.

New is the ima-appraise-measurement-required.patch, which resets
the appraisal flag when 'security.ima' is modified or removed.

Mimi Zohar (1):
  ima: appraise measurement required

 security/integrity/ima/ima_main.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

