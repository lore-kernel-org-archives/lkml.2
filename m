Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0HQQcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:32:47 -0400
Received: from mail.perches.com ([173.55.12.10]:1118 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab0HQQcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:32:45 -0400
Subject: Re: Usage of checkpatch.pl for other projects
From: Joe Perches <joe@perches.com>
To: Sylvestre Ledru <sylvestre.ledru@scilab.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1282061780.13818.3009.camel@zlarin>
References: <1269337074.12129.4674.camel@korcula.inria.fr>
	 <20100817160123.GL6193@shadowen.org>  <1282061780.13818.3009.camel@zlarin>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 09:32:42 -0700
Message-ID: <1282062762.24541.98.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 18:16 +0200, Sylvestre Ledru wrote:
> Le mardi 17 août 2010 à 17:01 +0100, Andy Whitcroft a écrit :
> > What sort of differences are you thinking about.
> At first, mainly basic things like space or not before a brace, if a
> brace should be on the same line as the if or not, etc. This kind of
> basic things.

It might be better to use a script that uses
a combination of patch, indent with some
project specific options and diff to highlight
how a proposed patch might vary from project
coding standards.

