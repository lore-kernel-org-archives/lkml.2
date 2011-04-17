Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1DQONz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 10:13:55 -0400
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:45141 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751085Ab1DQONt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 10:13:49 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Apr 2011 10:13:49 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-Id:Organization:User-Agent:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
  b=fivTz7vsS56qON6lCDlR+yywDoQLicfhndHpsCqpzjyGvh6KUlVgl6RsuNAMbqszUBOd2IlpQqiNrJLfkyw2v2bHfCV2MtCq6/U7jevxU11k0bJARtN1PgERQDIjty/NByFFE4vwLVNZtJTg7XHua2PW0dMzsbN+JnRRGK+DJ3k=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: FpqK8sEVM1mwVj.NFZO7jzhCm40Qp3QE3Gy2tftW30YZ5iD
 owhSClVSkMsAlFEm6tJd.ZAUzfax.Rc6F_FHyXBwQj5Ex6hCmIhgPpD6WdqQ
 Ptb8y964wKn7lgGvESespOXGmS15yK3o8whb0Q00XCFb2Gvlh4H6qxDcKqSR
 0CNd8X8NBsof1fKQFtuEOviI.MvJikr93BW2y6WdgZ34Bsi_TR.NPVLyF7Ln
 1ZuiGG85TP8oQXA8NfaTFWQxD0Lhg4_LOC1k1k7K8rz15P94Jo9QYiFp3axM
 3xV9O_0HZJvdtYciq7G7ld7YLxTCFcJU1u_MoTMYszO_r59Wy_lMJ3VtiA8A
 fhETctgkRqFHOTwo-
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #29672] [regression][ALSA][hda-conexant][2.6.38-rcX] external microphone sound too quiet
Date: Sun, 17 Apr 2011 10:07:06 -0400
Message-Id: <3577387.Ms3I5Hp20k@segfault.sh0n.net>
Organization: sh0n.net
User-Agent: KMail/4.6 beta5 (Linux/2.6.39-0.rc3.git2.0.fc16.x86_64; KDE/4.6.2; x86_64; ; )
In-Reply-To: <IqJL5EkbqD.A.A5F.k5uqNB@chimera>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera> <IqJL5EkbqD.A.A5F.k5uqNB@chimera>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 17, 2011 03:52:09 PM Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.37 and 2.6.38.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.37 and 2.6.38.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
It is continuing, using the external microphone the audio is too quiet no 
matter how loud I set it with PulseAudio.

The audio onboard Lenovo W500 laptop is: Conexant CX20561 (Hermosa)  

I have not had time to do any investigations to look at the git changes made.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=29672
> Subject		: [regression][ALSA][hda-conexant][2.6.38-rcX] external 
microphone
> sound too quiet Submitter	: Shawn Starr <shawn.starr@rogers.com>
> Date		: 2011-02-19 6:02 (58 days old)
> Message-ID	: <474630.25335.qm@smtp105.rog.mail.re2.yahoo.com>
> References	: http://marc.info/?l=linux-kernel&m=129809536502092&w=2
