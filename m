Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2ATPTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:19:25 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:44603 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753444Ab2ATPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:19:22 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0YOLTfAVM1ngFBmgDtZqJwqovDf5N7FeFVLbMbd7aYrhlpq
 Mn05YB1MfuAcWP5udyymQ9ONl8yOffIyJizE0CbX.4S1vGaq.MysD6tQ6rOH
 30y.1etqGYYBU9F6Lr_4hmyo9yVjC_GzSJ7SC3AWGAHoUVr6gjgx__q3ul98
 nOHr8WmmmvhnrXr9kwdE5lnE55Nm.B1wppXATWEl6JU5EqYTn3U2.hu7f8ES
 gsy4lt7vmgZvPiCK3.v0Ls4XUK0kX8UnY6x1.IsmDBPlSRFA1ZrmpFkCwKAg
 jcvtJyIojngr7NCrKGrWJvYFku.9dA0XM20DMIdO8Vzbm8Dre8O20T.IPjBV
 fs7mzRgo1kuR61OQiPM01q4Lsl4fsus26wGojv5CmFYXQhUEqukPLX.HwpG8
 -
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 20 Jan 2012 09:19:20 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] percpu: use bitmap_clear
In-Reply-To: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
Message-ID: <alpine.DEB.2.00.1201200918350.25941@router.home>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jan 2012, Akinobu Mita wrote:

> Use bitmap_clear rather than clearing individual bits in a memory region.

Acked-by: Christoph Lameter <cl@linux.com>
