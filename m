Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1HWPZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:25:20 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:37805 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754221Ab1HWPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:25:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: HG_eycsVM1nmJDb69_waY026KuwC8zKhQ9XhGxQkxDlKlXP
 Plu8xnwfbcuCPFuR7Grut_0oX.i_Coj0IqcsjcjqI.BRKz73VTmni1vZM8V7
 .41Ft5wzX_GLMWW1LmXHIHGphAtBQlw1YXjcepwQ70jf58nBXq1x9DqQ6At_
 a.arOhVAywdFNzJ_T4olDUlE2h3BCWDpM_8TwGvZVy4g6SeW.z4zXC2ZpZCg
 ryMP15dw4GTOIR8kfSNuE2tXyQ_mEkG5Rg5xjSJy7m.HE1Y4kDu4beQmKe7y
 JlRulGveZprI2CtDLA5FfVuX.qfNFhR.bDb5JbqnkaeB1hPRIBP2PyfhuSrZ
 Fr3Dc7S6Z40AHmHL.UVQJMVYMQfIFYXM1k2d0raCXvbtmjA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 23 Aug 2011 10:25:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Shaohua Li <shaohua.li@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>, penberg@kernel.org,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [patch 2/2]slub: add a type for slab partial list position
In-Reply-To: <1314059823.29510.19.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1108231023470.21267@router.home>
References: <1314059823.29510.19.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Shaohua Li wrote:

> Adding slab to partial list head/tail is sensentive to performance.
> So adding a type to document it to avoid we get it wrong.

I think that if you want to make it more descriptive then using the stats
values (DEACTIVATE_TO_TAIL/HEAD) would avoid having to introduce an
additional enum and it would also avoid the if statement in the stat call.

