Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab0LCOYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:24:19 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:63461 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0LCOYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:24:17 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Dec 2010 09:24:17 EST
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=XAFil4mTjq2QSJ/kh+KwdObDVLghA4NT64VLoTFGY2nLLc8o3kk1opK2JIea1EXv3+GCjZnLCsOl3LeWs6VGpr/bgMgd3ffFLsDuBE35ZOij+snJaqgEqeJY+F3VBTiZHle/9MJIOjRlstTXVaqh5aEeQaPM97WGYXIR4TkcrQs=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Jason Baron <jbaron@redhat.com>
Subject: [PATCH] Proposal to add dynamic debug feature for print_hex_dump [0/3]
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-0.4-default; KDE/4.5.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <201012031517.35062.roman.fietze@telemotive.de>
Date: Fri, 3 Dec 2010 15:17:34 +0100
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 03.12.2010 15:17:35,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 03.12.2010 15:17:36,
	Serialize complete at 03.12.2010 15:17:36
Content-Transfer-Encoding: 7bit
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason,

There will be following two small patches adding dynamic printk
support for print_hex_dump in two steps shortly.

The first patch will add a pr_ like wrapper as it already exists for
printk(<level>,..., e.g. pr_info. The second patch will finally add a
dynamic debug wrapper simply duplicating your work for printk debug
output.

These patches are against the current head of the torvald repos as of
today. If somebody asks for a patch against the last released version
I can provide those as well.


Roman

-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
