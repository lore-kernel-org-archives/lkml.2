Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2ITOl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab2ITOl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:41:26 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: [RFC] Second attempt at kernel secure boot support 
Date: Thu, 20 Sep 2012 10:40:55 -0400
Message-Id: <1348152065-31353-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is pretty much identical to the first patchset, but with the capability
renamed (CAP_COMPROMISE_KERNEL) and the kexec patch dropped. If anyone wants
to deploy these then they should disable kexec until support for signed
kexec payloads has been merged.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

