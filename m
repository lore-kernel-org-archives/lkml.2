Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2DWNsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 09:48:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50372 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2DWNsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 09:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <CANQmPXjoLvYe+X=TripkZi2s8JDG5pRYRYWS7FAMK_oixcHL7g@mail.gmail.com>
References: <CANQmPXh-cu9tOJfceNZRHCBKFwR1-D5gQJOdMsnjty_LeLAADw@mail.gmail.com>
	<CAJd=RBD4KaXtqiShWtDk3AWJb+ZQFEYEw41dZna=7am31jWVCw@mail.gmail.com>
	<CANQmPXjoLvYe+X=TripkZi2s8JDG5pRYRYWS7FAMK_oixcHL7g@mail.gmail.com>
Date: Mon, 23 Apr 2012 21:48:20 +0800
Message-ID: <CANQmPXgVoVH_nW_FLJatp33bXBF83b1DKFMkphu8opVJ56vZEw@mail.gmail.com>
Subject: Re: [PATCH] RIFS cpu scheduler
From: mou Chen <hi3766691@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This scheduler is designed for desktop user only.It won't work well on
Batch task scheduling.
