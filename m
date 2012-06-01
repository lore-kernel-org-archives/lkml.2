Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2FAGFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 02:05:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61739 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204Ab2FAGFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 02:05:19 -0400
MIME-Version: 1.0
In-Reply-To: <4FC82AFB.6020209@linux.intel.com>
References: <1338488391-20755-1-git-send-email-roland@kernel.org> <4FC82AFB.6020209@linux.intel.com>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 31 May 2012 23:04:56 -0700
X-Google-Sender-Auth: 3hhbEVW1i1e2pGDf0ZRcg4xA40U
Message-ID: <CAG4TOxNUjL6EbOFKy12=deBNZGkwezkx3=tu9a1U6NpUGTs3CA@mail.gmail.com>
Subject: Re: [PATCH] sb_edac: Only register mce_decode_chain once
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, please refer this:
> https://lkml.org/lkml/2012/5/8/62

Yes, your fix looks identical.  However your changelog makes it sound
a bit less severe that it is: on my system at least, it is an
immediate hard hang the first time sb_edac is loaded, rather than
requiring module unload or any memory errors to trigger.

Anyway I think the fix needs to get merged right away, and your patch
is fine with me.

 - R.
