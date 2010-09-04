Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0IDRYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 13:24:00 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:46411 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754460Ab0IDRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 13:23:58 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: cwYVzpoVM1lhcUI5mlsPuTL1SlebMSSbkOGF5IVmx6ENVVa
 6cbQaQObCeJID1LHH_iORmh.KZfmxyLBNqL.LaMmLF0qeZPJdE5A7EHLSbAg
 UBErGNB01AIgS.zQUVgbOxrE32SpZj4XPR_ot21lwv8d9UJjS6Rs3LJN0Zni
 fK63z7luCzAk3baHJMqWjofwRRwFWF_UnT6N3o0HS.DxZum6MvNgvBTPLRI5
 N
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 4 Sep 2010 12:23:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Richard Cochran <richardcochran@gmail.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH 0/2] [RFC] posix clock tuning
In-Reply-To: <cover.1283504065.git.richard.cochran@omicron.at>
Message-ID: <alpine.DEB.2.00.1009041221240.888@router.home>
References: <cover.1283504065.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Richard Cochran wrote:

> Recently on the lkml, we discussed how to allow adjustment of posix
> clocks. I have tried to understand and implement the ideas expressed
> in the various threads.
>
> If there is agreement on this approach, I will resubmit these two
> patches as part of a longer series, including support for a new kind
> of hardware clock, so you can see how it all fits together. But first,
> I would like to concentrate on the new syscall itself.
>
> The patches are against a recent net-next tree. Please don't worry if
> the syscall tables are not quite up to date. I can fix that later.

Could you explain why the existing interfaces are not sufficient that do
what you describe?

man adjtime
man adjtimex
man clock_settime
?

Why would you need this to support a new hardware clock? You want the
clock to run at a different speed from system time?

