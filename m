Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab1DUBly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 21:41:54 -0400
Received: from trent.utfs.org ([194.246.123.103]:34574 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab1DUBlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 21:41:53 -0400
Date: Wed, 20 Apr 2011 18:41:50 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: colin@colino.net
cc: LKML <linux-kernel@vger.kernel.org>
Subject: therm_adt746x: attach_adapter method is deprecated
Message-ID: <alpine.DEB.2.01.1104201837010.18728@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Starting with 2.6.38+, I noticed the following messages during bootup:

i2c i2c-0: attach_adapter method is deprecated
Please use another way to instantiate your i2c_client

adt746x seems to continue to work, though. This is on a PowerBook G4.

Is this something to be worried about?

Thanks,
Christian.
-- 
BOFH excuse #40:

not enough memory, go get system upgrade
