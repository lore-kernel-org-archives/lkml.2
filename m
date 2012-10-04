Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2JDWez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:34:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2JDWey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:34:54 -0400
Date: Fri, 5 Oct 2012 00:34:29 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>
Subject: PRJQUOTA case not handled in need_print_warning()
Message-ID: <alpine.LNX.2.00.1210050032220.3873@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit e8a3e4719b7ec19288c56f22623f537cb78885c1
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Sun Sep 16 01:11:45 2012 -0700

    userns: Implement struct kqid

causes this warning:

fs/quota/dquot.c: In function ¡need_print_warning¢:
fs/quota/dquot.c:1158: warning: enumeration value ¡PRJQUOTA¢ not handled in switch

and it seems to be a valid one -- the switch in need_print_warning() 
contains neither 'default' nor PRJQUOTA case handler.

-- 
Jiri Kosina
SUSE Labs
