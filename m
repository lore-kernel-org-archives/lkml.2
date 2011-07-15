Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1GONLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:11:33 -0400
Received: from smtpauth21.prod.mesa1.secureserver.net ([64.202.165.38]:37844
	"HELO smtpauth21.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751139Ab1GONLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:11:31 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jul 2011 09:11:31 EDT
Date: Fri, 15 Jul 2011 09:12:34 -0400
From: MK <mk@cognitivedissonance.ca>
To: linux-kernel@vger.kernel.org
Subject: Re: AVX "Sandy Bridge" hardware issue?
Message-Id: <20110715091234.087d94a2.mk@cognitivedissonance.ca>
In-Reply-To: <m2k4bn57j4.fsf@firstfloor.org>
References: <20110712161616.b5196a3b.mk@cognitivedissonance.ca>
	<m2k4bn57j4.fsf@firstfloor.org>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 17:49:35 -0700
Andi Kleen <andi@firstfloor.org> wrote:
> If there's a problem then it's likely in the VM. Maybe it leaks
> AVX partially through only.
> 
> For example I had a similar problem a long time ago on a system
> which had inconsistent CPU features for different CPUs. The kernel
> will chose the least common denominator, but an application
> directly calling CPUID can sometimes see different flags and then
> crash when it switches CPUs.
> 
> The symptoms would be consistent with that.
> 
> I would contact the VM vendor.

I think I will go the developer list for openVZ first and get some more
info.  The vendor is trepidatious as no one else has had a problem (I
dunno how many, if any, of the other clients use mod_perl) and this
could be an unsolvable headache headache for them.

Thanks all for the input!

-- 
"Enthusiasm is not the enemy of the intellect." (said of Irving Howe)
"The angel of history[...]is turned toward the past." (Walter Benjamin)

