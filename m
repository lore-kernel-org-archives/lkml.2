Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab1C1SOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:14:42 -0400
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:58322 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754816Ab1C1SOk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:14:40 -0400
MIME-Version: 1.0
In-Reply-To: <4D90CDDE.1020500@df1tl.local.here>
References: <4D90CDDE.1020500@df1tl.local.here>
From: Roland Dreier <roland@purestorage.com>
Date: Mon, 28 Mar 2011 11:14:19 -0700
Message-ID: <AANLkTikzU=zNrjs=mnLnxm3SUBAyVpWF5UmkJvXFnF-G@mail.gmail.com>
Subject: Re: 2.6.37.6 2.6.38.2 tst-aio4.c
To: Klaus Dittrich <kladit@arcor.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 11:05 AM, Klaus Dittrich <kladit@arcor.de> wrote:
> Reverting the patch of kernel/signal.c which was
> applied to 2.6.37.6 and  2.6.38.2 solved the problem.

Indeed, I found that the same patch was to blame.  Fix coming shortly.
