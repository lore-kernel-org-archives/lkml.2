Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab1AFQuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:50:23 -0500
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:45202 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449Ab1AFQuW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:50:22 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 11:50:21 EST
X-AuditID: 12074424-b7b0bae000000a05-3d-4d25f1a07607
Subject: Re: [PATCH] System Wide Capability Bounding Set
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <201101062030.AIC51020.HOLOFQSJFtVFMO@I-love.SAKURA.ne.jp>
Date: Thu, 6 Jan 2011 11:44:48 -0500
Cc: eparis@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, serue@us.ibm.com,
        sgrubb@redhat.com
Content-Transfer-Encoding: 8BIT
Message-Id: <B5F8D700-2471-4C88-B4EB-5A44F3529492@mit.edu>
References: <1294266337.3237.45.camel@localhost.localdomain> <201101062030.AIC51020.HOLOFQSJFtVFMO@I-love.SAKURA.ne.jp>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAARcU4pU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 6, 2011, at 6:30 AM, Tetsuo Handa wrote:

> An LSM module can provide ability to aggregate several tasks into a group
> (called "security context" or "domain") and grant permissions against groups.
> We can selectively grant whatever capabilities against groups.
> Why do we need to get bothered by capability inheritance problem?

Yes, but LSM modules still can't stack, last I checked.  So people would need to choose between this or SELinux, or build this capability into every single LSM module....

-- Ted

