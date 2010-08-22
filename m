Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab0HWICU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:02:20 -0400
Received: from santostefano.inria.fr ([193.51.192.151]:39095 "HELO
	santostefano.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752816Ab0HWICQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:02:16 -0400
Subject: Re: Usage of checkpatch.pl for other projects
From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1282062762.24541.98.camel@Joe-Laptop>
References: <1269337074.12129.4674.camel@korcula.inria.fr>
	 <20100817160123.GL6193@shadowen.org>  <1282061780.13818.3009.camel@zlarin>
	 <1282062762.24541.98.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 22 Aug 2010 22:50:29 +0200
Message-ID: <1282510229.10764.2972.camel@zlarin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 août 2010 à 09:32 -0700, Joe Perches a écrit :
> On Tue, 2010-08-17 at 18:16 +0200, Sylvestre Ledru wrote:
> > Le mardi 17 août 2010 à 17:01 +0100, Andy Whitcroft a écrit :
> > > What sort of differences are you thinking about.
> > At first, mainly basic things like space or not before a brace, if a
> > brace should be on the same line as the if or not, etc. This kind of
> > basic things.
> 
> It might be better to use a script that uses
> a combination of patch, indent with some
> project specific options and diff to highlight
> how a proposed patch might vary from project
> coding standards.
This might be a good way to start. 
We could also create a configuration file with default being the Linux
Kernel's coding styles.

Sylvestre

-- 
-------------------------
Sylvestre Ledru
-------------------------
The Scilab Consortium
Digiteo
Domaine de Voluceau
Rocquencourt - B.P. 105
78153 Le Chesnay Cedex
France

