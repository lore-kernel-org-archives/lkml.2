Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab1KPOrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:47:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:58594 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1KPOrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:47:40 -0500
Date: Wed, 16 Nov 2011 15:47:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Kacur <jkacur@redhat.com>
cc: lkml <linux-kernel@vger.kernel.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH] Fix typo in use of BUG_ON_NONRT macro for RT
In-Reply-To: <1321361887-544-1-git-send-email-jkacur@redhat.com>
Message-ID: <alpine.LFD.2.02.1111161546550.4902@ionos>
References: <1321361887-544-1-git-send-email-jkacur@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Nov 2011, John Kacur wrote:

> In drivers/md/dm.c BUG_ON_NORT should be BUG_ON_NONRT

Right. I had that fix already, just forgot to refresh the patch. One
day I will teach quilt to do that for me :)
 
