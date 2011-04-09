Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1DIWkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 18:40:43 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:53118 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab1DIWkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 18:40:14 -0400
Date: Sun, 10 Apr 2011 00:30:43 +0200
From: Marc Koschewski <marc@osknowledge.org>
To: linux-kernel@vger.kernel.org
Subject: nice values zeroed after hibernate/suspend?
Message-ID: <20110409223043.GA23372@marc.osknowledge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E 38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.kosik.org/pubkey.asc
X-Blog: http://www.kosik.org/blog/
X-Operating-System: Linux marc 2.6.39-rc2-dezzy-11174-gbb3c90f-dirty
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I could report a false positive here when I'm dumb but ... it seems like the
nice values given to a process (-20) are zeroed (=0) when I resume. Could anyone
please re-test this?

Regards,
Marc

-- 
Marc Koschewski
