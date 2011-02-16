Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1BPW6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 17:58:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:50598 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab1BPW57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 17:57:59 -0500
Date: Wed, 16 Feb 2011 14:56:54 -0800
From: Greg KH <gregkh@suse.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Driver core: convert platform_{get,set}_drvdata to
 static inline functions
Message-ID: <20110216225654.GB6881@suse.de>
References: <1297895007-2104-1-git-send-email-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297895007-2104-1-git-send-email-mkl@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 11:23:27PM +0100, Marc Kleine-Budde wrote:
> This patch converts the macros for platform_{get,set}_drvdata to
> static inline functions to add typechecking.
> 
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

Much better, I'll add this to my queue.

thanks,

greg k-h
