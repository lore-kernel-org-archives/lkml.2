Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab1L0Srm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 13:47:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1L0Srk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:47:40 -0500
Date: Tue, 27 Dec 2011 13:47:34 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hskinnemoen@google.com
Subject: Re: Linux 3.2-rc7
Message-ID: <20111227184734.GA5802@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	hskinnemoen@google.com
References: <CA+55aFxw1abaxwQbX=sQVF-J6drk8m5cKCd+rMqrpoS5vohmnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxw1abaxwQbX=sQVF-J6drk8m5cKCd+rMqrpoS5vohmnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 10:16:06PM -0800, Linus Torvalds wrote:
 > There it is, likely the last -rc in before final 3.2, so please do
 > check it out in between your holiday festivities.
 > 
 > Most of the changes are faily simple one-liners, but some qla4xxx
 > driver updates stand out and in fact account for about 40% of the diff
 > ("qla4xxx: fix flash/ddb support"). That, together with a VMWare DRI
 > driver update and some dvb updates and the regular random driver fixes
 > means that 80+% of the changes are in drivers.
 > 
 > Some net updates, some SH updates, and then a (tiny) smattering of
 > other stuff. The appended shortlog gives the (fairly boring) details,

https://lkml.org/lkml/2011/11/22/753 has been around since rc2, and is
still appearing every boot for me.  I'm not sure if Havard had patches
fixing this or not, I lost track.

	Dave

