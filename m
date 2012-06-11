Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab2FKVFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:05:04 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:39922 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751840Ab2FKVFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:05:02 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 25xBpSEVM1mQuhdWDWSrv0W_59Yng1Y4Q.6rntTh90s1xwb
 oFa46okweGdWSKndpCJGsFasmMBZsUfhbW3jXEBwE3L_KIFZ1fR9NQCRT.D2
 CUkg5LNwHR94GQCITTPClm7q1n8BlC38e875a04eNo7004Mh4.WgnPEicog7
 6SEoK99qHjezQYCmB1GXHC9KCuwaokhvhsGFpSsUzSrTJ3znnkzuD5mOqV3N
 k7dym8QDChh3l99kvlRBgbnsAtDq8Hn1GKwwHuP9BZFv11CNCYnCVEx4SYgl
 6T1jcBPIlkGQRc.u2_bh6WP.C8j.L9RDflQZCHBCjzc22.Uqkjg_BgFOsivD
 xmqmALxf1qL4qe4QRaIssZLKy0Y4G2Z211ySPRm8KsjA9oxnf2xO.T3v_7Hx
 p
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 11 Jun 2012 16:04:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix protection column misplacing in /proc/zoneinfo
In-Reply-To: <CAHGf_=rbss0RsoFn7NZ7oFCpCZuEYkPDXaHSW4KHg=Vu8703xA@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1206111602540.9391@router.home>
References: <1339422650-9798-1-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1206110856180.31180@router.home> <4FD60127.1000805@jp.fujitsu.com> <alpine.DEB.2.00.1206111336370.4552@chino.kir.corp.google.com>
 <CAHGf_=rbss0RsoFn7NZ7oFCpCZuEYkPDXaHSW4KHg=Vu8703xA@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, KOSAKI Motohiro wrote:

> Several years, some one added ZVC stat. therefore, hardcoded line

You are talking to the "some one".... The aim at that point was not the
beauty of the output but the scaling of the counter operations. There was
no intention in placing things a certain way. I'd be fine with changes as
long as we are sure that they do not break anything.

