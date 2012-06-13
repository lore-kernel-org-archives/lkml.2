Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab2FMLi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:38:59 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4046 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753726Ab2FMLi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:38:57 -0400
Subject: Re: gcc compiler modification to cater for new programming language
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Chris Jones <chrisjones@spin.net.au>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>
Date: Wed, 13 Jun 2012 13:38:45 +0200
In-Reply-To: <4FD6EA5B.5030905@spin.net.au>
References: <4FD40035.2020200@spin.net.au>
	 <CAM_iQpXyMhx5JszEew1O9ehQ0z-eOCZ_DjpdFPNJuKfVafcL3g@mail.gmail.com>
	 <4FD6EA5B.5030905@spin.net.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339587528.18982.39.camel@thorin>
Mime-Version: 1.0
X-DCC-x.dcc-servers-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2012-06-12 at 17:06 +1000, Chris Jones wrote:
> Cong Wang wrote:
[...]
> > Yeah, you need to write a gcc front-end for it.
>
> Why would you suggest writing a front-end for it? I think you're wrong 

Because that's the right thing to do?!

> there as a front-end has nothing to do with the functionality of gcc. 
> Explain to me why you would suggest this? Curious.

Get a basic course in compiler-contruction and learn, what "frontend"
and "backend" in a compiler are.
But you could also write a parser which parses the new/other programming
language and produces C which in turn can be compiled a an unpatched
gcc.

> I am aware it is off-topic and have also brought it up on the gcc 

Then why are you posting it anyways?

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

