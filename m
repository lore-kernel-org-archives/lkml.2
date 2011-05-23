Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab1EWSpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:45:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44000 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab1EWSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PwgK1EUsq2LhZwPsLHfuy/H/AeENfWUZtBDmkSdiHgXmqwpJSIAzotqOEzfYTPTbPo
         ubhfNR+H6n7WOIvStenUINv1eaNBPs9vhluXMYcE+JC0qZeTyosNjuptO8qhWb7W/3R/
         SdGWdZDTjPx3X2P85ujjAz5FZO0+7KKqGs2XM=
From: Jim Cromie <jim.cromie@gmail.com>
To: rdunlap@xenotime.net
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH 0/3 rev2] fix scripts/export_report.pl
Date: Mon, 23 May 2011 12:44:54 -0600
Message-Id: <1306176297-6964-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305966108-13399-4-git-send-email-jim.cromie@gmail.com>
References: <1305966108-13399-4-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks Randy,

rev2 fixes:
NB -> NOTE
cant -> cannot
CONFIG_MODVERSION -> CONFIG_MODVERSIONS (everywhere)

