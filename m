Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0E1LeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 07:34:18 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:40558 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab0E1LeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 07:34:16 -0400
Date: Fri, 28 May 2010 13:35:14 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Documentation/timers/hpet_example.c compile bug
Message-ID: <20100528113514.GA3686@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

since your commit e61863099f58e458f08c101da87da752a1e009f5
"Documentation/timers/: split txt and source files" I get this compile
error on s390 with an allyesconfig:

In file included from Documentation/timers/hpet_example.c:15:
/usr/include/linux/hpet.h:11: error: expected specifier-qualifier-list before 'u64'

Please fix.

Thanks!
