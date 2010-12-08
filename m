Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab0LHBzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:55:44 -0500
Received: from web37602.mail.mud.yahoo.com ([209.191.87.85]:26009 "HELO
	web37602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756955Ab0LHBzl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:55:41 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Dec 2010 20:55:41 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=z5m9hAgOJJoCu5VT/6Lp0vcvIb+WKk515dK4nsmJda1xdQeJkI5zCslI3PVxmhrP20XmIuC/VVGo5GP5huBKCKdYy9XGunt3gikCgXJEWwX+8tGwgCqg9t/xCLEXEfCxUrgOf47ZTympEAB5hqbCTC+T5tjkncnJGjaVTa+vCC4=;
Message-ID: <361937.19792.qm@web37602.mail.mud.yahoo.com>
X-YMail-OSG: CoZIMgkVM1ntIqluWz5VfLIi2FfqEguTn9IggSrGhfgnZ8e
 GXyqB2RiCowM6TBH7eZI6q2lwTiapunjHCKCpY_8nzA5qWnkPvlV6Zv1xU0N
 kCyCRS3QDkFJ4q_.90UhAjcVqiiYTaufDuh5muxFpOWPQ5CKJNgtV35VmnTs
 PaQPry4ruXFTkmHkcAmJow.geBImJeV4QdJMmoYtZQdxnrE4ZNtKMGvlMA6F
 wo1FGXyUVIiQdkjSts5z4UWfP8wqVRjEh1vDcNrkLUDjtlQtTXTv9nYUz8Po
 uUx5vrnKBpCer7.EVRm6djVVojsXAfBlKWEHxvyDRvrl3asfsMpL4ndhEM7Y
 BfUEw
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Tue, 7 Dec 2010 17:48:59 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 3/3] memstick: Add support for JMicron JMB 385 and 390 controllers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Aries Lee <arieslee@jmicron.com>,
        Takashi Iwai <tiwai@suse.de>
In-Reply-To: <1291708599-28026-4-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody.

It appears, this series of patches rectifies the issues with Jmicron
discussed earlier.

Andrew, can we put in my last four small patches as well?



      
