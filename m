Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1AFLab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 06:30:31 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:59346 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1AFLa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 06:30:29 -0500
To: eparis@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: serue@us.ibm.com, sgrubb@redhat.com
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1294266337.3237.45.camel@localhost.localdomain>
In-Reply-To: <1294266337.3237.45.camel@localhost.localdomain>
Message-Id: <201101062030.AIC51020.HOLOFQSJFtVFMO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 6 Jan 2011 20:30:24 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> Not so long ago the global capability bounding set was removed from the
> kernel.  Instead we created a new per task capability bounding set which
> was inherited by children.

An LSM module can provide ability to aggregate several tasks into a group
(called "security context" or "domain") and grant permissions against groups.
We can selectively grant whatever capabilities against groups.
Why do we need to get bothered by capability inheritance problem?
