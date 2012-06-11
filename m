Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2FKPBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:01:20 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:39633 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755292Ab2FKPBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:01:19 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zmnrykgVM1nygcr8Oryi6BT6bWjFtrKcfESFCnzngdkUoES
 g.cDHjYwOewY0v53U7WrWix8EshKUdIgf4w.6vKI4C5BXPLCXt_5ISBXdm.k
 ciXbI6ZRJ3d7hH5XVHHML8PdMCUHgWpeOkemzUMzSq5RwMB9jKPnkiZo6to8
 6jhLHNxLCN.a6JXsSsKdjrC0744sWdSZAkmleNU3J.keDlHu8w0maz42RzwZ
 nOex5G.SKuEEZ6bqW_7GcvsXjn7NmzISibNLSRZmBPnj.jXT8KexOqex4Awx
 JX9clgZ0U5ufmJ29Wzmfnu4pqu79goH7PqLvxtY_tusEcPyCjKNenNrAwSX0
 Rx_VyxaI18d.gyJ1i81TFMsi_klIvKylqL3qlJjaR9brjj7NPJiMktkoy4ci
 IdwRr5W9TdkLnZXZzCYlTrEWX34CJfHPSVR5v
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 11 Jun 2012 10:01:15 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: kosaki.motohiro@gmail.com
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>, stable@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 0/6][resend] mempolicy memory corruption fixlet
In-Reply-To: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
Message-ID: <alpine.DEB.2.00.1206110934200.31180@router.home>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012, kosaki.motohiro@gmail.com wrote:

> changes from v1: fix some typo of changelogs.

I still have a hard time with the changelogs. Will try to give you
hopefulyl better ones.

Again you need to CC Andi Kleen on this. He wrote most of the shared
mempolicy code (long time ago) and then Lee started tinkering with it.

