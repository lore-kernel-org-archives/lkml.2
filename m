Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161448Ab1FAJ0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:26:18 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:64667 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161376Ab1FAJ0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 05:26:14 -0400
X-RZG-AUTH: :IXQkeEW8Yfo/5haL0ckzWIsAYh739YBunhBBa3aCCiaR1pO3uOmbj2ao6A==
X-RZG-CLASS-ID: mo05
From: Stefan Metzmacher <metze@samba.org>
To: Oliver Neukum <oliver@neukum.name>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: cdc_ncm: device gets unregistered on resume
Date: Wed,  1 Jun 2011 11:13:49 +0200
Message-Id: <1306919630-13426-1-git-send-email-metze@samba.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed the cdc_ncm module doesn't have a .reset_resume hook,
while the cdc_ether module has it.

metze

