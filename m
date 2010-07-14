Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0GNGd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:33:59 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:53792 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab0GNGd5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:33:57 -0400
X-AuditID: 1209190c-b7c34ae000000a06-55-4c3d5a543f1e
Subject: Re: stable? quality assurance?
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4C3CD060.50904@davidnewall.com>
Date: Wed, 14 Jul 2010 02:33:48 -0400
Cc: Marcin Letyns <mletyns@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EB078C22-C9B8-42D5-AC05-2852228034D0@mit.edu>
References: <201007110918.42120.Martin@lichtvoll.de>	<20100711131640.GA3503@thunk.org>	<4C3ABA35.7020507@davidnewall.com> <AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com> <4C3B3B39.2000809@davidnewall.com> <4735EF77-6C7D-46D6-8C2B-C910A2D662D2@mit.edu> <4C3CD060.50904@davidnewall.com>
To: David Newall <davidn@davidnewall.com>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 13, 2010, at 4:45 PM, David Newall wrote:
> 
> Calling it stable instils and reinforces a Pavlovian response in typical users, that recent Linux kernels are dangerous and unreliable; one year old was suggested as a safe benchmark. Typical users being 99% of the population, testing hardly begins until a kernel is "sufficiently old." This Pavlovian response is what really delays finding and fixing bugs. Being up-front and saying which kernels are likely to fail would help many users calculate the risk and improve their willingness to try newer kernels. "Sufficiently old" might well come down to six months, maybe four.

Most typical users should be using distribution kernels.  Period.

We can't say which kernels are likely to fail, because we don't know.  If people don't test newer kernels, the mere passage of time, whether it's four months, or six months, or a year, or two years, is not going to magically make problems go away and get fixed.   That only happens if someone steps up and tries it out, and if it breaks submits bug reports or patches.   A fairly large number of Linux developers seem to prefer relatively recent vintage Thinkpads, preferably without Nvidia or ATI chipsets.   These laptops are generally safe and reliable by -rc3 or so --- because if they aren't the Linux developers step up and complain and do code bisections and they fix the problem.

If someone has a T23 laptop, and they help out by doing the same, then it will also be safe and reliable by the time of 2.6.X.0.   If they just kvetch and complain, and stamp their feet, and say "Linux is unsafe and unreliable", and no other T23 owners step up to the challenge, then two years might go by and the same kernel might still be unreliable --- for them.

-- Ted

