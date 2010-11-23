Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0KWOLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:11:48 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:2581 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab0KWOLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:11:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEJAMpZ60x5LdQd/2dsb2JhbACUYYECjQByvUeFSwSKXg
Message-Id: <20101123140610.292941494@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 24 Nov 2010 01:06:10 +1100
From: npiggin@kernel.dk
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/7] icache dirty / sync fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inode dirty / sync handling seems totally broken. I'd like some comments
on this series.


