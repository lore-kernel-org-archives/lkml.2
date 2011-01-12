Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1ALUXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:23:33 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:43070 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752263Ab1ALUX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:23:29 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: y3nm_CoVM1mkVWh368Y11oLZnIz9keSxyk6mhPB_xIMZqPK
 AG.sAPGsOm9M9zJsE8eNr5ZyecCDNmlcHbGYF61CBWekpY_wPJjX0e3vVZ3M
 bjlbqpOXKT12wz4NbijV6tf5Jh3OuDCEB5QftguLVyK4VCgdXXGWhofpnErk
 i.WZNm4d9Fg_fb2eASekObdS0rd3xEcO2o3c2Xb.a8Ghye.3YOjvyW.4h0dO
 QthVSHSQfT0Q8zGspbBCb.jFbYcihQyEoGJto7R9l4pPaE.y5gMZoTHBgJn0
 aoMJb3VTT4EgiQQ9rVQgbZFMxJv8CpBvcwr1qTPIDRHxsQR4-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 12 Jan 2011 14:23:25 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric B Munson <emunson@mgebm.net>
cc: akpm@linux-foundation.org, linux-mm@kvack.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Rename struct task variables from p to tsk
In-Reply-To: <20110112201602.GA25957@mgebm.net>
Message-ID: <alpine.DEB.2.00.1101121421490.9271@router.home>
References: <1294845571-11529-1-git-send-email-emunson@mgebm.net> <alpine.DEB.2.00.1101121205120.3053@router.home> <20110112201602.GA25957@mgebm.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011, Eric B Munson wrote:

> On Wed, 12 Jan 2011, Christoph Lameter wrote:
> > Use t instead of p? Its a local variable after all.
>
> I don't find t any more informative than p.  As a newcomer to most of this code
> informative variable names, even for local variables, is a huge help.

Local variables are short because they are defined close to the point of
use.

tsk is not that informative and the notion of a "task" can refer to
various. However, when I see

	struct task_struct *t;

I know what it refers to.

