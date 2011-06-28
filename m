Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab1F1TcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 15:32:18 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:29380 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750733Ab1F1TcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 15:32:12 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9BzUKRgVM1lPCBwzKd7i3nVhAN.WgzUtEyC_7veLoQkNmAl
 ybyhYVcUBJpkevN0mubJSSzO7lC1PCQBn7mF03ccuupnQ8bsINZvfAv5PcTt
 9ZLa9pKgJ22YPnG7iBeA1YKhnmeIx1HiB3CpcFwdbQ.ygSSQwAxBqBiCki2d
 FMwEgO7wwmSJizIbEbI2XPeTpPCVMWk2O015Uh36u5dHtv0e3qYRRKSALmGp
 2Jw78rxsRwN2kVh3H2F90HWiyVqC.JY7pg2ZbKeRwqnBso7omqr0YQNpSTyI
 HeNCi2bevNDcw0ppZ7_8sysFENFDUBey__4KGoa.170TRNVH5JWcwD3v4BY7
 7ycWCS5qOBzaf2K2ELxDhXPpY
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 28 Jun 2011 14:32:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Marcin Slusarz <marcin.slusarz@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
In-Reply-To: <20110626193918.GA3339@joi.lan>
Message-ID: <alpine.DEB.2.00.1106281431370.27518@router.home>
References: <20110626193918.GA3339@joi.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jun 2011, Marcin Slusarz wrote:

> slub checks for poison one byte by one, which is highly inefficient
> and shows up frequently as a highest cpu-eater in perf top.

Ummm.. Performance improvements for debugging modes? If you need
performance then switch off debuggin.

