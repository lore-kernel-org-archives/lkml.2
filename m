Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1GONMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:12:18 -0400
Received: from smtpauth16.prod.mesa1.secureserver.net ([64.202.165.22]:54651
	"HELO smtpauth16.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751902Ab1GONMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:12:16 -0400
Date: Fri, 15 Jul 2011 09:06:39 -0400
From: MK <mk@cognitivedissonance.ca>
To: linux-kernel@vger.kernel.org
Subject: Re: AVX "Sandy Bridge" hardware issue?
Message-Id: <20110715090639.5550ac11.mk@cognitivedissonance.ca>
In-Reply-To: <4E1CB768.6060304@genband.com>
References: <20110712161616.b5196a3b.mk@cognitivedissonance.ca>
	<4E1CB768.6060304@genband.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 15:06:48 -0600
Chris Friesen <chris.friesen@genband.com> wrote:
> For what it's worth, Intel says the E31230 supports AVX as well:
> 
> http://ark.intel.com/Product.aspx?id=52271

Thanks for that.
 
> As far as I can tell, support for saving/restoring AVX registers was 
> added in 2.6.30, but gcc 4.6 is needed for proper support to actually 
> use the new instructions.  However, given that you're using openVZ
> then if there is a bug in the kernel all it would take is one VPS
> slice using code built with a new compiler.

I might try building a new gcc (since there is no 4.6 binary for
F14) and then testing that way.




-- 
"Enthusiasm is not the enemy of the intellect." (said of Irving Howe)
"The angel of history[...]is turned toward the past." (Walter Benjamin)

