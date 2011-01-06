Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab1AFMLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:11:35 -0500
Received: from nm12.bullet.mail.ne1.yahoo.com ([98.138.90.75]:30179 "HELO
	nm12.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753324Ab1AFMLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:11:33 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 513448.97620.bm@omp1010.mail.ne1.yahoo.com
Message-ID: <839814.56179.qm@web113319.mail.gq1.yahoo.com>
X-YMail-OSG: asmEq0sVM1lC.Tzch51sx3DvtZicEkMlFKegOhbwKv.A4I2
 jYn3bHgjfbU0GtmFN5QT4mdJxrtGQKBX8zYYTUHOq1E1qdCKA9c9vVsZVWHf
 .sI.Thb._FCWQS8blhuQ.rIx4PznEdpteQr1DIEBrRHR5mkgXpx8LRYzDpeX
 9X9HhNhBebsG1.qmTmJ33JFFO.gl7.CHV5B._eNTGVMh4W4WdSfV7wGhsACz
 JwEYU3UrVJMWY22_SQuZxXdypWmrjnDL5A1BSx4Zw4g0Im6atiTU4DexypuD
 AKuwoyooYVC6F91ORl9r6OpjBu0AByp2z_MhRJFKnIRyC.17HD4ZyTsG4Llo
 shJdBWPesXrZqbXBrUyK0V4GMwG21VLR0Q5Lt6X3r.nCLL05GWpFg
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
References: <20110104055900.GA5062@bicker>  <20110104163836.GA30317@fieldses.org>  <20110104164414.GX5875@const.bordeaux.inria.fr>  <1294160834.6617.51.camel@Joe-Laptop> <m3fwt7i740.fsf@intrepid.localdomain> <1294249529.6617.118.camel@Joe-Laptop>
Date: Thu, 6 Jan 2011 04:11:31 -0800 (PST)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
To: Joe Perches <joe@perches.com>, Krzysztof Halasa <khc@pm.waw.pl>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Dan Carpenter <error27@gmail.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <1294249529.6617.118.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Joe Perches <joe@perches.com>
> To: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>; J. Bruce Fields 
><bfields@fieldses.org>; Dan Carpenter <error27@gmail.com>; Andy Whitcroft 
><apw@canonical.com>; linux-kernel@vger.kernel.org; 
>kernel-janitors@vger.kernel.org
> Sent: Wed, January 5, 2011 6:45:29 PM
> Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
> 
> > Increasing e.g.
> > readability of the code would be a good reason, but  statistics?
> 
> Standardization of style in a large project  increases
> readability and decreases errors full stop.

 Anything that prevents errors from happening is good. No question.
 Anything that enforces "style" for no good reason is just counterproductive
 "readability" is a personal thing. It cannot be increased by enforcing "style". 
Not for everybody.

 And when discussing this issue we should not forget the environment. If I am a 
programmer working for a big$$$ company, I better follow their style-guide (if 
they have one). They pay my food and shelter after all. If I am "just" a 
volunteer on some mainly volunteer open source project, why should I care about 
"in my opinion" crap style. It will just drive me away from that project.

 Again as I wrote elsewhere - all depends on context. If a contribution is just 
a small patch to existing work one can easily follow the "style" of the existing 
work. If it is genuinely new work, it should be valued by the peers on technical 
merit, not on whether they like the contributors way of writing out an 
condition.

> 
> Outside of that,  it's _all_ bikeshedding.

 Your shed is my castle

> 
> cheers, Joe

Cheers
Martrin (to hell with style)
