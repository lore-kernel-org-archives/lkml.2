Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0KIKom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:44:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab0KIKol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:44:41 -0500
Date: Tue, 9 Nov 2010 11:44:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] tty: prevent DOS in the flush_to_ldisc
Message-ID: <20101109104430.GA4459@jolsa.brq.redhat.com>
References: <1288163451-3973-1-git-send-email-jolsa@redhat.com>
 <20101108134840.GA3275@jolsa.brq.redhat.com>
 <20101108140938.06b7ee65@lxorguk.ukuu.org.uk>
 <20101108180147.GB3275@jolsa.brq.redhat.com>
 <20101109103539.089fae14@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109103539.089fae14@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:35:39AM +0000, Alan Cox wrote:
> > The attached patch (based on -next tree) fixes this by checking on the
> > tty buffer tail. Once it's reached, the current work is rescheduled
> > and another could run.
> 
> Looks nice and tidy
> 
> Alan

would you advise on whom to send it to pick it up?

thanks,
jirka
