Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab1FVVXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:23:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57820 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023Ab1FVVXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:23:16 -0400
Message-ID: <4E025D39.80600@zytor.com>
Date: Wed, 22 Jun 2011 14:23:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: OpenRISC Architecture: Request for review
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
In-Reply-To: <1308483825-6023-1-git-send-email-jonas@southpole.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2011 04:43 AM, Jonas Bonn wrote:
> Notes
> -----
> 
> See the file README.openrisc for information on getting a toolchain and
> simulator for building and running this code.
> 
> We currently have only a uClibc port to this architecture and this does
> not fully support the reduced set of generic syscalls.  In our upstream
> submission we have included only the reduced set of syscalls, while we
> will be carrying an out-of-tree patch that enables Linux to work with our
> uClibc port until we are able to sort this out.  This shouldn't, however,
> need to further delay beginning the code review.
> 
> There's a short TODO.openrisc file, as well.  Some of the items listed
> there could potentially be done before any pull request for the architecture
> is sent.
> 
> There are also fair number of places where we still have old test code
> laying about inside #ifdefs and comments.  The intention is to get all that
> cleaned up before the final pull request, but I didn't want to allow that
> to delay beginning the review process any further.
> 

Do you also have any ready-made ports for any common FPGA boards that
one can test it out on hardware with?

	-hpa
