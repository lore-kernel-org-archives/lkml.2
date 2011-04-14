Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab1DNS2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:28:17 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:44889 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932959Ab1DNS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 14:28:12 -0400
Date: Thu, 14 Apr 2011 20:28:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: George Spelvin <linux@horizon.com>, davej@redhat.com,
        linux-kernel@vger.kernel.org, joro@8bytes.org
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110414182800.GA32000@ucw.cz>
References: <20110413043246.24974.qmail@science.horizon.com>
 <BANLkTi=owU+pg299PPNryhL2DbEpBTDEoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=owU+pg299PPNryhL2DbEpBTDEoQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Note that the discussion on the libmount mailing list revealed a possible
> > kernel workaround: escape the hyphens as \055.  Damn hard to read for
> > a human, but it does parse correctly, and the workaround can be fixed
> > once the library updates have propagated.
> 
> I'd rather replace it with some non-dash character that is
> human-readable, like '+' or some utf-8 sequence that _looks_ like a
> dash.

Just delete the dashes? IIRC UUIDs are fixed length binary numbers, so
no info will be lost.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
