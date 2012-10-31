Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839Ab2JaVeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:34:22 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58707 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759980Ab2JaVeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:34:19 -0400
Date: Wed, 31 Oct 2012 17:34:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Martin <dave.martin@linaro.org>
Cc: Tekkaman Ninja <tekkamanninja@gmail.com>, Harry Wei <harryxiyou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH]Documentation: Chinese translation of
 Documentation/arm/kernel_user_helpers.txt
Message-ID: <20121031213415.GB17305@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Martin <dave.martin@linaro.org>,
	Tekkaman Ninja <tekkamanninja@gmail.com>,
	Harry Wei <harryxiyou@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nicolas Pitre <nicolas.pitre@linaro.org>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20121030162004.GA3467@Super-MAGI>
 <20121030190349.GC5044@thunk.org>
 <20121031110619.GC3780@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031110619.GC3780@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:06:19PM +0100, Dave Martin wrote:
> 
> What's the best way of making sure that changes in the source document
> propagate to translated versions?
> 
> It might be enough to put a note in the source document to remind people
> to check for the extistence of translated versions and CC the relevant
> translation maintianers with any patches affecting the source document.

What I was suggesting was even more light-weight.  Just include at the
very beginning or the very end of the the file the last time the
translation was updated, and either the kernel version (i..e, v3.6) or
the git commit ID (i.e., df981d03eeff) that was used for the source
document.

That way, someone who reads the file will know how "fresh" the
document is, and the reader can do a "git log -p
Documentation/arm/kernel_user_helpers 1234567890abcd.." to see all of
the changes made to the file since the last time the translation was
updated.

People will inevitably remember to forget to notify the translation
maintainers, and as the number of translations go up, the more
workload we put on the everyone else.  If we simply mark the
translation, then the translators can poll to refresh the document at
their leisure, or perhaps this allows anyone who is using the
translated documentation file and who has a reasonable command of
English to do the "git log -p ..." command and perhaps contribute a
patch to update the translation.  So I think this approach would scale
much better.

					- Ted
