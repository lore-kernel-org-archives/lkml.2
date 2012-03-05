Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab2CEU0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:26:00 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54635 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757691Ab2CEUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:25:59 -0500
MIME-Version: 1.0
Date: Mon, 5 Mar 2012 21:25:58 +0100
Message-ID: <CAEmqk_z=RtBsKaRE4ZE3wvuOjOs=CeXKvb+1iGu6bhQ_Vw-KEw@mail.gmail.com>
Subject: Why unprivileged user cannot set SECBIT_NOROOT etc. via prctl?
From: Kant <fnord.hammer@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason why this shouldn't be allowed? It seems incredibly
stupid that you first have to gain privileges to be able to do this.
