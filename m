Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab2JaLCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 07:02:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39174 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab2JaLCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 07:02:16 -0400
Date: Wed, 31 Oct 2012 12:06:19 +0100
From: Dave Martin <dave.martin@linaro.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Tekkaman Ninja <tekkamanninja@gmail.com>,
        Harry Wei <harryxiyou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH]Documentation: Chinese translation of
 Documentation/arm/kernel_user_helpers.txt
Message-ID: <20121031110619.GC3780@linaro.org>
References: <20121030162004.GA3467@Super-MAGI>
 <20121030190349.GC5044@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030190349.GC5044@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 03:03:49PM -0400, Theodore Ts'o wrote:
> On Wed, Oct 31, 2012 at 12:20:04AM +0800, Tekkaman Ninja wrote:
> > This is a Chinese translated version of
> > Documentation/arm/kernel_user_helpers.txt
> > 
> > Signed-off-by: Fu Wei <tekkamanninja@gmail.com>
> 
> I wonder if it woiuld be a good idea to note the git commit id of the
> kernel version that was used as the source document for the
> translation.  That way in the future, someone can just do a "git log
> -p" to find all of the changes since the original version of the
> translation, and use that to update the translation.
> 
> Just a suggestion,

What's the best way of making sure that changes in the source document
propagate to translated versions?

It might be enough to put a note in the source document to remind people
to check for the extistence of translated versions and CC the relevant
translation maintianers with any patches affecting the source document.

Cheers
---Dave
