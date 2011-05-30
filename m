Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1E3GBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:01:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58853 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1E3GBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=hlXVkqyZYju9S9un97KAg/K4/LxnuIEOYxYI+dk9HdYgLoilUnaBi8FfN1JQxx8dtp
         j3u8jKExL0cM0iuuadnV4y7mqJ9+ffRPddcd+MsWYqkMmGKL6DN9PMsG8ZZcMFlTaQwq
         OvLPaZAjvFYpcmU4qpc3NiDLPNdr4hhhDBbhQ=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0-rc1
Date: Mon, 30 May 2011 08:01:10 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-final-dirty; KDE/4.6.3; x86_64; ; )
References: <BANLkTinE8eSSovGx6CPPkTeCpqv8AsS2nw@mail.gmail.com> <20110530020711.GY3956@zip.com.au>
In-Reply-To: <20110530020711.GY3956@zip.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105300801.10321.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 of May 2011, CaT wrote:
> On Sun, May 29, 2011 at 06:30:32PM -0700, Linus Torvalds wrote:
> > Now, my alpha-maleness sadly does not actually extend to all the
> > scripts and Makefile rules, so the kernel is fighting back, and is
> > calling itself 3.0.0-rc1. We'll have the usual 6-7 weeks to wrestle it
> > into submission, and get scripts etc cleaned up, and the final release
> > should be just "3.0". The -stable team can use the third number for
> > their versioning.
> 
> Why not just keep the sublevel 0 for your release and let stable team
> modify it for their release. That way you release 3.0.0, 3.1.0, 3.2.0
> and stable do 3.0.1, 3.1.3, 3.2.1, etc. Less script breakage that way.

I guess some distros will do that way on their own.

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
