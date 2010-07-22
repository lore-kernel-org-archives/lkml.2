Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab0GVOkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:40:52 -0400
Received: from THUNK.ORG ([69.25.196.29]:50869 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab0GVOku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:40:50 -0400
Date: Thu, 22 Jul 2010 10:40:48 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Notes to filesystem developers....
Message-ID: <20100722144048.GC14882@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-kernel@vger.kernel.org
References: <20100722114931.GA18205@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722114931.GA18205@bitwizard.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rogier,

I think most of what you have written are things which have already
been implemented in ext4.  Please see:

http://thunk.org/tytso/blog/2008/08/08/fast-ext4-fsck-times/
http://thunk.org/tytso/blog/2009/02/26/fast-ext4-fsck-times-revisited/

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/presentations/ext4-fast-fsck-lk2009.pdf

						- Ted
