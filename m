Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0JRQgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:36:09 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:23477 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751362Ab0JRQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:36:08 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: hSXmL_cVM1lFulzBZVkf6j6sz6XHKYQfXJg7DFUqL8FKqoO
 9aClbDsPj52LPenpbXeCMY_0xPMqStT_XGktFbjjixFTk_A7FX6dLr3fBUHe
 ihxNPZY4pIXfeSTJ1YgWTZYTtt7SLqVdE_LIuGHTbCaKqTtx52ZzMeWptgxE
 XCME2iI2gA6Gr.W_ZAyvxfNJp4bC8hJ06fiIRpwxa3fkN5Toq6X4_aLqFMvA
 .L6oOXuyOZx.z1RUTi3Zx7zgftTt3irBD
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 18 Oct 2010 11:36:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Young <hidave.darkstar@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] Add vzalloc shortcut
In-Reply-To: <20101016043331.GA3177@darkstar>
Message-ID: <alpine.DEB.2.00.1010181135290.2092@router.home>
References: <20101016043331.GA3177@darkstar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010, Dave Young wrote:

> Add vzalloc for convinience of vmalloc-then-memset-zero case

Reviewed-by: Christoph Lameter <cl@linux.com>

Wish we would also have vzalloc_node() but I guess that can wait.

