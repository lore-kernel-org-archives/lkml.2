Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab0HQQ6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:58:34 -0400
Received: from santostefano.inria.fr ([193.51.192.151]:60985 "HELO
	santostefano.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755088Ab0HQQ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:58:33 -0400
X-Greylist: delayed 1941 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Aug 2010 12:58:32 EDT
Subject: Re: Usage of checkpatch.pl for other projects
From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walker <dwalker@fifo99.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100817160123.GL6193@shadowen.org>
References: <1269337074.12129.4674.camel@korcula.inria.fr>
	 <20100817160123.GL6193@shadowen.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 18:16:20 +0200
Message-ID: <1282061780.13818.3009.camel@zlarin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 août 2010 à 17:01 +0100, Andy Whitcroft a écrit :
> On Tue, Mar 23, 2010 at 10:37:54AM +0100, Sylvestre Ledru wrote:
> > Hello,
> > 
> > I saw the very interesting presentation of Greg at the last FOSDEM where
> > he explained how to write a patch of the kernel. 
> > 
> > During his presentation, he presented the script checkpatch.pl which
> > checks the coding style of a patch / file. 
> > 
> > For a while, I have been looking for such script which can check the
> > compliance of a source code against a coding policy.
> > 
> > Obviously, the coding style of my project is not exactly the same as he
> > Kernel one. 
> > 
> > Therefor, I would like to know if there is any plan of making a
> > dedicated project of this piece of software to allow usage of it for
> > other projects.
> > If it is not the case, is it possible to contribute to change the
> > behavior of the policy check (of course, disable by default for kernel
> > hackers) ?
> 
> An interesting question.  Cirtianly most of its behaviour is kernel
> centric.  The source kinda lives outside the kernel with its tests
Is there a dedicated website for this project ?

> so could be consumed by other projects (though we do keep a copy in the
> kernel tree too).  If changes could be conditional on the project I
> could see it being possible.  What sort of differences are you thinking
> about.
At first, mainly basic things like space or not before a brace, if a
brace should be on the same line as the if or not, etc. This kind of
basic things.

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

