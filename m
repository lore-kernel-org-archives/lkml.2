Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab1I0QQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:16:57 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:41543 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751380Ab1I0QQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:16:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: blGpq6gVM1lCvTrUN8BYXt98Pdvjc83nJ9vBR.c0FgQ8OWu
 WpRlLNvcRiw30IVhW7utBw4jkhck_8NttUCD_oI_88eATptNle4iQuN76q5f
 hPZL2uxZj.RWGIKHqxDprKuOsdWQV0heTueOiUCDVIWLLwraz1Re1FwR5bJR
 g0WE3bZATq7YM9CjgIIXgc_wg.bMwC2dDXCZqpfJN5KG0Rhj1DB5Ij92REV_
 ER6fB.oUxLd6PaBmAxtTxWvikU6RetBcysAc88.8P3v.OJyEeK2t51ynAwqf
 .HDRaoeMh8SK50xe2.BWay15fQ3PO0vrVwd5kUP.eROeZtX2wnwG0eFGQ3E1
 3q0RnR2K_XlLgePteU4ZXuudSz0CIjkPvnov9fHpk6ssHoBZW3Fj39NaW8m2
 pfyiE
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Sep 2011 11:16:51 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Balbir Singh <bsingharora@gmail.com>
cc: Steven Rostedt <rostedt@goodmis.org>, Greg Thelen <gthelen@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        PeterZijlstra <peterz@infradead.org>
Subject: Re: [PATCH] memcg: Fix race condition in memcg_check_events() with
 this_cpu usage
In-Reply-To: <CAKTCnznH1WWsVaPQfRF5u9VKvOL6D8cxP0239XhKe8_mG4J35w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1109271115571.9569@router.home>
References: <1316825684.6387.5.camel@gandalf.stny.rr.com> <CAHH2K0Z_MsVceOjoFwT=qORSsKrFWjs_V602NMtPBysasJLEww@mail.gmail.com> <CAHH2K0agLygD6cREazsTquCT=Whx97RxxhOneWpVF1cHwMwp3A@mail.gmail.com> <1316832094.6387.11.camel@gandalf.stny.rr.com>
 <CAKTCnznH1WWsVaPQfRF5u9VKvOL6D8cxP0239XhKe8_mG4J35w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Balbir Singh wrote:

> Thanks for the correction. The change looks good to me

Same here.

Acked-by: Christoph Lameter <cl@gentwo.org>
