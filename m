Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1FFVSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 17:18:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41768 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab1FFVSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 17:18:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aAyIZ53D4seR0yh099DiccGn0Y5YEduJ0Q1El/KNEbE8DQyElj1lK+ZD6eVlbk3ZQg
         q5baxxSzKH6yA9g2MUjRzEZyt9Iw0mG14cLE1+fVPMeq8OZOR8GGddUFCH/3zmuyosc/
         zuWiTiF937/iAGMxEx/nn2glRv3H4MrbrNShA=
Date: Tue, 7 Jun 2011 00:18:14 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] seq_file.h: introduce DECLARE_SEQ_FOPS_{RO,RW}
Message-ID: <20110606211814.GA27405@p183.telecom.by>
References: <201106061319.45855.hartleys@visionengravers.com>
 <20110606210755.GL11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606210755.GL11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 10:07:55PM +0100, Al Viro wrote:
> On Mon, Jun 06, 2011 at 01:19:45PM -0700, H Hartley Sweeten wrote:
> > Many of the procfs and debugfs attribute file_operations in the kernel are
> > missing the .owner information. Introduce some macro's to fill in the .owner
> > field as well as the common methods for virtual file file_operations.  This
> > simplifies creating the attributes and makes sure all the fields are properly
> > initialized.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> Nacked-by: Al Viro <viro@zeniv.linux.org.uk>
> Nacked-because: too ugly
> 
> Don't play that kind of games with preprocessor.

3) .owner is ignored for procfs
4) ## breaks grep (and tags)
5) macro name doesn't hint for important "single" piece.
6) DECLARE and DEFINE semi-idioms are used another way :^)
