Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0LVEBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 23:01:50 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52553 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0LVEBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 23:01:49 -0500
Date: Wed, 22 Dec 2010 13:00:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas@winischhofer.net
Subject: Re: [PATCH 00/13] Further sisfb cleanups
Message-ID: <20101222040016.GF30700@linux-sh.org>
References: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292881822-32630-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 11:50:09PM +0200, Aaro Koskinen wrote:
> Here's some further cleanups for sisfb. The most visible change is that
> sis_main.c is changed to use the same register I/O functions that other
> files are using.
> 
Applied, thanks.
