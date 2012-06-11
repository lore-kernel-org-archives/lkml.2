Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2FKODG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:03:06 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:22152 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754251Ab2FKODD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:03:03 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: g.voe6wVM1kTHbVu0eoQtLnY69j5Sgmy_9zvZMmSsoaXYno
 mCcQIADzVxz_y8lfHYWVAxq1mZq0k8P.Kx7JnnASFd0clRYT5.HNq6DpNbV1
 o8FHlMJzkck2Vo30eUprbytyPflhJApsCVTU8USUp5WuPbVwDn73a9arkgyn
 m9gZDiQG9b0PKCLKnb5poirT2g6Gv2wYkSPNSHFNangwld.6mTnQWdWFgIw_
 DmJb1Qw_Qgp5HxYlUR.PIe4ND.oF17FKUJaPJG2BN74TVvbxnrHPpQolC5xu
 Ihmme1LiMRPPmKG7q.NS0lKrJK3wf_tsV505d_ePr7X2jtwhkc2iahnHCftP
 jdb8wCRPBGTCD_jp54FmsSpkbGpneFIa0S.TMG1Yo4a_17UdM4i30Ym8_97o
 P
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 11 Jun 2012 09:02:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: kosaki.motohiro@gmail.com
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm: fix protection column misplacing in /proc/zoneinfo
In-Reply-To: <1339422650-9798-1-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.DEB.2.00.1206110856180.31180@router.home>
References: <1339422650-9798-1-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> commit 2244b95a7b (zoned vm counters: basic ZVC (zoned vm counter)
> implementation) broke protection column. It is a part of "pages"
> attribute. but not it is showed after vmstats column.
>
> This patch restores the right position.

Well this reorders the output. vmstats are also counts of pages. I am not
sure what the difference is.

You are not worried about breaking something that may scan the zoneinfo
output with this change? Its been this way for 6 years and its likely that
tools expect the current layout.

