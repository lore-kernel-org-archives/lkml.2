Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab0GTC1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 22:27:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981Ab0GTC1P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 22:27:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100719181240.fc3066cd.randy.dunlap@oracle.com>
References: <20100719181240.fc3066cd.randy.dunlap@oracle.com>
Date: Mon, 19 Jul 2010 19:27:13 -0700
Message-ID: <AANLkTilwV9PPdpM5JZ65M_TYr_XfVDBHCLXLJVYkTEav@mail.gmail.com>
Subject: Re: [git pull] documentation: fix almost duplicate filenames 
	(io/IO-mapping.txt)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Kees Bakker <kees.bakker@xs4all.nl>,
        Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 6:12 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> (hopefully I got this right.  I'm not a big git user.)

Hmm. No.

The commit otherwise looks correct, but the commit message is
buggered. The first line of the message is

   From: Randy Dunlap <randy.dunlap@oracle.com>

rather than the subject of the patch itself.

No fear. Practice makes perfect. Just try again ;)

                Linus
