Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2BMO7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:59:54 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:34402 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756740Ab2BMO7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:59:53 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Z516B7wVM1kEDCUqemMAd7weREz23KPCu12Avq9Z0cDGvYQ
 Bmb8GBH6m2BNpopLW9ZODlRNbQKZRWLlyKPay2oKXBJlD.LPD262rSY.DRU8
 wDVvw6.zzCPnGN1sYbCgzvLecsotQFtO1pkk5_3FECxNIAuT1NnDTEh1GNum
 Wn1WWiMoUAZl9xEDD0DL91JYXoT.RAya0r_KgmxbgFMan2S8.YTh_2TZjn4I
 VOiwVhxs4q1I5jUH8E7i28ojaTBstl_FLNsE8fxxYLDpLs_Ri6nOV5VQzks2
 hIJ7QhEr7SzrreGoWrqveUqOQjIhgn5n3.BYmnFEIn9J6HHQrTym_1wNbSnc
 OJx718ug.hzmJKtgrpXB3MhMAx7arwui8w11yCiSC70PYfYHLOvY1bTY3AB8
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 13 Feb 2012 08:59:50 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ming Lei <tom.leiming@gmail.com>
cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: use raw_local_irq_* in _this_cpu op
In-Reply-To: <1329131018-19107-1-git-send-email-tom.leiming@gmail.com>
Message-ID: <alpine.DEB.2.00.1202130859340.23562@router.home>
References: <1329131018-19107-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012, Ming Lei wrote:

> It doesn't make sense to trace irq off or do irq flags
> lock proving inside 'this_cpu' operations, so replace local_irq_*
> with raw_local_irq_* in 'this_cpu' op.

Acked-by: Christoph Lameter <cl@linux.com>
