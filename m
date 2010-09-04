Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0IDOGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 10:06:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59319 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab0IDOGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 10:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qx0K5Xxd0lGvVh7AXZIB2uMAk09y+6As8GTmVbtnCz+cbeSiHyGDZPGxbF4YKG44K6
         daxsye1SmeaxFchUtmCqdNBUSsvTgxkZxhz5/ylP2/PypRP+q4Y/HNwKMKqfT8Rl9n0w
         X7NOIEHo0BKD2QrKkBMbi9MbPlkAPZHEPr2e0=
Date: Sat, 4 Sep 2010 16:06:39 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH 1/2] posix clocks: introduce a syscall for clock tuning.
Message-ID: <20100904140639.GA22074@riccoc20.at.omicron.at>
References: <cover.1283504065.git.richard.cochran@omicron.at>
 <7f4815cdfcf5bc49df4bdd09d59a4f56ca2598f5.1283504065.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f4815cdfcf5bc49df4bdd09d59a4f56ca2598f5.1283504065.git.richard.cochran@omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 11:29:05AM +0200, Richard Cochran wrote:
> A new syscall is introduced that allows tuning of a POSIX clock. The
> syscall is implemented for four architectures: arm, blackfin, powerpc,
> and x86.
> 
> The new syscall, clock_adjtime, takes two parameters, the clock ID,
> and a pointer to a struct timex. The semantics of the timex struct
> have been expanded by one additional mode flag, which allows an
> absolute offset correction. When specificied, the clock offset is
> immediately corrected by skipping to the new time value.

Sorry, last sentence should read, "corrected by adding the given time
value to the current time value."

Richard
