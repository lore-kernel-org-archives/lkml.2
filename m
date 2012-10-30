Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965577Ab2J3TDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:03:54 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58505 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab2J3TDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:03:52 -0400
Date: Tue, 30 Oct 2012 15:03:49 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Tekkaman Ninja <tekkamanninja@gmail.com>
Cc: Harry Wei <harryxiyou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Dave Martin <dave.martin@linaro.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH]Documentation: Chinese translation of
 Documentation/arm/kernel_user_helpers.txt
Message-ID: <20121030190349.GC5044@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Tekkaman Ninja <tekkamanninja@gmail.com>,
	Harry Wei <harryxiyou@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nicolas Pitre <nicolas.pitre@linaro.org>,
	Dave Martin <dave.martin@linaro.org>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
References: <20121030162004.GA3467@Super-MAGI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030162004.GA3467@Super-MAGI>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:20:04AM +0800, Tekkaman Ninja wrote:
> This is a Chinese translated version of
> Documentation/arm/kernel_user_helpers.txt
> 
> Signed-off-by: Fu Wei <tekkamanninja@gmail.com>

I wonder if it woiuld be a good idea to note the git commit id of the
kernel version that was used as the source document for the
translation.  That way in the future, someone can just do a "git log
-p" to find all of the changes since the original version of the
translation, and use that to update the translation.

Just a suggestion,

				- Ted
