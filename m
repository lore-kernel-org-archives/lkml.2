Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0L3OrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 09:47:07 -0500
Received: from keetweej.vanheusden.com ([83.163.219.98]:59422 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0L3OrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 09:47:05 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2010 09:47:05 EST
Date: Thu, 30 Dec 2010 15:37:31 +0100
From: folkert <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: block device without page cache buffering
Message-ID: <20101230143731.GO9658@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Dec 22 20:04:01 CET 2010
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

What should a block device driver need to do to get all read/write
requests without any buffering from the page cache?
I think the iscsi initiation does this.
This is needed to get an existing pseudo block device to function as a
shared storage so that a cluster filesystem (gpfs/ocfs) can be put on it (nbd).


Folkert van Heusden

-- 
Nagios user? Check out CoffeeSaint - the versatile Nagios status
viewer! http://www.vanheusden.com/java/CoffeeSaint/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
