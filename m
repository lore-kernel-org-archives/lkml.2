Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab2IJUDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 16:03:45 -0400
Received: from nm30-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.160]:36577 "HELO
	nm30-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751363Ab2IJUDn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 16:03:43 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Sep 2012 16:03:43 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 418295.32209.bm@omp1057.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=O5XEsnHKscmP0Ls3DBju5vqlKGqTrkVWFS5/sbAbDMoUju2nEdS+m8NLx25/nWIIiTNmKTP2zmIrAM/LsbyqVwLQsyI3rzRdw8CCp/Nr3EXrupHxQ4xPvUGFgk5t3ieWVUF2Qj34WJHA8bmE8ofJfhtT6+4cDFn+6GkZxK4AzJM=;
X-YMail-OSG: WINhk_4VM1lJZ2OP1T2lK7nHB8pJPs8UMNYWIJY2ltnhEFk
 HCvBV3K4ufk5neYRANzgUT_87fRShYSfGfdAGiR.B5XrjHKFIDT9mY_cVeTi
 rcU6JZUQXjLQgM5gtjzjj8cU9VHdbzijX0NkNHvta881OQVQUi5f2CYedvSW
 wbPLBvOl5y90rXAsWSDhytrqOuApv5ToabWZJ856ydSpJ7xtbO222qbcpb.k
 m9VGZm5tmCdZkKFI92Ic4ZlNaWY54SubujnByVSK4v0bgcxVaUxWOK5.x73r
 vhOQK_9Yr7JORd11guQSQxkSbc8_5hLM5gP3JJRr8lhC.WI_WMaaXjpZH2yo
 N8tZmJn0Ow5pu2wAtMTLNnQY4NBTK1iDDEMNSu4kFOKU3cGc24T7jw426O7S
 v9U73Md.CbSQlIOD_xKXiuAuMDJl2y3M0YNRolbIzB5atd991_.Zc3_L0Gl2
 sugsBvMv1ZDDowQ4g0TkzDV9HMRrWn27xxsNlsdHV
X-Mailer: YahooMailWebService/0.8.121.416
References: <504B4F2D.40002@yahoo.com> <s5hligitcd0.wl%tiwai@suse.de> <1347272938.6237.YahooMailNeo@web120301.mail.ne1.yahoo.com> <s5hfw6qtbhq.wl%tiwai@suse.de>
Message-ID: <1347307103.57319.YahooMailNeo@web120304.mail.ne1.yahoo.com>
Date: Mon, 10 Sep 2012 12:58:23 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [alsa-devel] snd-intel-hda: screaming IRQ with 3.5.3 kernel (HDMI)
To: Takashi Iwai <tiwai@suse.de>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hfw6qtbhq.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> Did you try any workaround boot options such as irqpoll, pci=nocrs or whatever?


OK, the "irqpoll=1" option does help here. Although this message is obviously scary:

Misrouted IRQ fixup and polling support enabled
This may significantly impact system performance


And the "pci=nocrs" option does Really Bad Things to the display at boot-time.

So what is "irqpoll" actually doing, please? Is it just a temporary workaround for a driver bug?

Thanks,
Chris

