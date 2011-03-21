Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab1CUXrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:47:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56518 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab1CUXqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:46:37 -0400
Date: Mon, 21 Mar 2011 23:46:29 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl: never finishes w/ specific file
Message-ID: <20110321234629.GA5939@localhost>
References: <201103021731.01598.toralf.foerster@gmx.de>
 <20110316114752.GI1407@shadowen.org>
 <201103211142.11317.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201103211142.11317.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 11:42:10AM +0100, Toralf Förster wrote:
> 
> Andy Whitcroft wrote at 12:47:52
> > Could you try your file with the one below and let me know:
> > 
> >  
> > http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl
> 
> I've a question about line 1365 :
> 	if ($realfile =~ m@^include/asm\/@) {
> 
> IMO either both "/" or none needs to be escaped, or ?

None as we are using '@' as the separator, however the extra \ is
benign.

-apw
