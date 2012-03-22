Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab2CVTas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:30:48 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:44670 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753015Ab2CVTar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:30:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: eFpPH64VM1kRwbqSavUMQPcDSMVkySZoBMLr1caw1YxvSiX
 Qc7xMFCBdQMvqAKO0H4xUsmEWEa7fdqx0PmGb6x7DWcP7mHV5a7QJipCR2qm
 .tGBmcHC3n4aKavlTfrqkSmV6IM2L59Ki3mZh6oBi3qPhe1GjiGPAeMwfDrj
 gT_.WHT4hGG9GFAzwgPp8l5TT6l9nBpDhThBuXPuTxLA7kMnbpYU0FXiV74J
 3oEpHmNhpdy2.S8QTYbvuRL1NBvglHOja.udxNv_Sc2fnenP2J5P8JqhQz8g
 tC9qzZKHUs9GZ8sKhl19oUh8sZ_ZqOBsW_fjqvxi7ifqVUeftzZQXQz7dFyU
 yoq6.jjy2tOWA7i.vK3YQS2bZFz7flyxBIvDUnAbIK8srT8Xyu.K9AoDVTF2
 XDf9FC0Wg.98HTKjXuAeTarFtJ9r3aemIN.Zu
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 22 Mar 2012 14:30:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Larry Woodman <lwoodman@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
In-Reply-To: <4F6B7854.1040203@redhat.com>
Message-ID: <alpine.DEB.2.00.1203221421570.25011@router.home>
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home> <4F6B7854.1040203@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Larry Woodman wrote:

> > Application may manage their locality given a range of nodes and each of
> > the x .. x+n nodes has their particular purpose.
> So to be clear on this, in that case the intention would be move 3 to 4, 4 to
> 5 and 5 to 6
> to keep the node ordering the same?

Yup. Have a look at do_migrate_pages and the descrition in the comment by
there by Paul Jackson.


