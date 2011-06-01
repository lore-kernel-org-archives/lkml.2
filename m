Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab1FAMCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:02:01 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:56981 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab1FAMB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:01:58 -0400
X-RZG-AUTH: :IXQkeEW8Yfo/5haL0ckzWIsAYh739YBunhBBa3aCCiaR1pO3uOmbj2ao6A==
X-RZG-CLASS-ID: mo05
From: Stefan Metzmacher <metze@samba.org>
To: Oliver Neukum <oliver@neukum.name>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] usbnet/cdc_ncm: add missing .reset_resume hook
Date: Wed,  1 Jun 2011 14:01:40 +0200
Message-Id: <1306929701-22861-1-git-send-email-metze@samba.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E568@EXDCVYMBSTM006.EQ1STM.local>
References: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E568@EXDCVYMBSTM006.EQ1STM.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here comes the patch with the DRIVER_VERSION change.

Are there chances to get this also backported in stable kernel.
I need it for 2.6.38.x (ubuntu 11.04).

metze

