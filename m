Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2JET2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 15:28:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52456 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2JET2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 15:28:02 -0400
From: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: 3.4.10 i915 [GM45] regression
Date: Fri, 05 Oct 2012 21:27:14 +0200
Message-ID: <3480968.71aklkfOSt@tux200s>
Organization: Andreas Sturmlechner
User-Agent: KMail/4.9.2 (Linux/3.6.0-ownage; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CAKMK7uEuRN1WerdF1KEDzova4Qe_hY20i3N=HeNVwvRYxf6gsw@mail.gmail.com>
References: <2372445.fuIXicT4H0@tux200s> <6616255.1baV4zcIkN@tux200s> <CAKMK7uEuRN1WerdF1KEDzova4Qe_hY20i3N=HeNVwvRYxf6gsw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So 3.5 and later really don't seem to have any issue with this patch.
> I'm as puzzled as ever. Thanks for testing this again.
> 

Bad news from 3.6: I got a blank screen there too, yesterday. Maybe it had even happened in 3.5 once before I got into testing all those 3.4/3.0 images - at my weekend setup there's an external DVI display that won't be fired up by the X200s anyway if the timing isn't right, so that new bug could go by unnoticed there.

So it seems the trouble still exists in >=3.5, but it happens way, way less often (my laptop boots once or twice per day). I should get my other system back up running to be able to try and SSH into the laptop next time this happens at home - just in case I could provide any useful output?

Best regards
