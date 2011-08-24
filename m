Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1HXJs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:48:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32951 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115Ab1HXJs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:48:26 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: eric.piel@tremplin-utc.net, jnelson-suse@jamponi.net, devel@acpica.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, hpa@zytor.com
Subject: [PATCH 0/2] Implement overriding of arbitrary ACPI tables via initrd
Date: Wed, 24 Aug 2011 11:48:08 +0200
Message-Id: <1314179290-31526-1-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series got some basic testing already (see patch 2 changelog) and
is based on latest 3.1-rc2 Linus kernel.

The patches are separated into ACPICA parts (patch 1) and kernel parts (patch 2).

They are ready for integeration (if now objections should show up in a review
discussion) and it would be great if they can be added in Len's latest acpi-test
tree for broader testing.

Thanks,

   Thomas

