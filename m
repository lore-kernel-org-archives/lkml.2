Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab1JDSGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 14:06:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:57761 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab1JDSGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 14:06:31 -0400
Date: Tue, 4 Oct 2011 20:06:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Salter <msalter@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 12/24] C6X: interrupt handling
In-Reply-To: <1317746641-26725-13-git-send-email-msalter@redhat.com>
Message-ID: <alpine.LFD.2.02.1110042005370.18778@ionos>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com> <1317746641-26725-13-git-send-email-msalter@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Oct 2011, Mark Salter wrote:

> From: Aurelien Jacquiot <a-jacquiot@ti.com>
> 
> Original port to early 2.6 kernel using TI COFF toolchain.
> Brought up to date by Mark Salter <msalter@redhat.com>
> 
> Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
> Signed-off-by: Mark Salter <msalter@redhat.com>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de> - who hopes that we
can get rid of that copied around code ASAP

