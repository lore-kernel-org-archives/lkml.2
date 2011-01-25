Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1AYMEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:04:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64330 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1AYMEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:04:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=oqusWP00P3BKw+LJgpXpxE6ey/qm5AnZzmeapQEg5I9LJdeaxUzqwQdagiQihZb3zw
         Zfbnnor9icEMfFZ5Q9dCcMWwwFN+WC+8bwndwMD35t+Cu2oMu3StYrBEgQe27bxF+VGI
         eTNX8m0q3/Gl59olwgi2pCypFGnlqK6WcW69c=
Date: Tue, 25 Jan 2011 15:04:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 01/12] staging: ft1000: Use common return point.
Message-ID: <20110125120415.GC2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Marek Belisko <marek.belisko@open-nandra.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295955083-11086-1-git-send-email-marek.belisko@open-nandra.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There isn't any point to this patch.  A common return point is useful
for releasing allocations and for unlocking locks but neither of those
are needed here.  It just makes the code more complicated for no reason.

regards,
dan carpenter
