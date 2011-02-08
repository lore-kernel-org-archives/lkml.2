Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1BHL7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 06:59:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39958 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1BHL7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 06:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=Q9dg/D3d1rkcWAahZ/m3id46sUrfT4ATfJowoVezUlmz4ob0PwylcGKCDx2S4y0Cs8
         SDzb8hm8W0zEWJp7cDoas363UJIpBa4l6l5gb4wHWjW5p7/OJBFEve10hYQqkN2ciSdI
         RScvnd/7U8/3qepMwOSe3mIYO8IpAD/dqrd/4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: dilinger@queued.net, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH RFC resend] Remove _strtoul() function.
Date: Tue,  8 Feb 2011 12:59:42 +0100
Message-Id: <1297166383-25390-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Done on top of those patches:
# [PATCH 1/4] olpc_dcon: get rid of global i2c_client, create a dcon_priv struct   Andres Salomon
# [PATCH 2/4] olpc_dcon: change sysfs 'output' toggle to be clearer...   Andres Salomon
# [PATCH 3/4] olpc_dcon: move more variables into dcon_priv   Andres Salomon
# [PATCH 4/4] olpc_dcon: actually return the value of i2c_add_driver   Andres Salomon

Marek Belisko (1):
  staging: olpc_dcon: Remove _strtoul() function.

 drivers/staging/olpc_dcon/olpc_dcon.c |   57 +++++++++++++--------------------
 1 files changed, 22 insertions(+), 35 deletions(-)

