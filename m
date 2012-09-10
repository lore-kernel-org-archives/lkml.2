Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2IJKeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:34:36 -0400
Received: from nm11-vm2.bullet.mail.ne1.yahoo.com ([98.138.90.159]:48428 "HELO
	nm11-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751533Ab2IJKee convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:34:34 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Sep 2012 06:34:34 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 810236.17070.bm@omp1037.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=MyA/X+OYf8XztF63Q7zrlZvp7k+prCOHrqBdZlC3NzjG1cq2TGxlqZVsYQdv5EzCS9y6206jB6+2SjlF2E4uG6l4w3ob40PcWc6+mEd94PiG66elLe+1aaaPQt5OxIYemSFeGPRfkieYaRT6LlZxx+gxDNWsuU0rr++p1tdr+6w=;
X-YMail-OSG: S_fpy6EVM1lv4gFagEdz3iEEhmwZl1cFS87Kjmd9vQxtOSj
 K6faFtv1s1jXRherJX9dEmtQ5tBYJA6rD_0GN.jdVlbzti503RCv.aUZspgE
 hwqwNvQ663CALeGWeXAKQ1O9SyRus3DUgdDOutiy9whtMD0aPQ_rqib2fwES
 .S6yWZUF9ZrjE4iXHTYlehJ8zs3aOtHf_E3ilKbGSsGKixlyvi7kJY1msqkF
 G0LXP5YtQ9KJoRdHs5kL45AqGiTcVgzBLxg.C3lWivTW2BVNO_uVACSqNNNV
 VFUcQHio62C7Sk40lvYuDAxtmHfDvpxKtZARuZg.kGcEHTYRyJWN6IR4h6GZ
 2YvNCTXJ.A3eJM_K14fp20vBaZ1YlIK6RN2FbD8otlfwG_ComE0C3Bx9yOEW
 WHBmcMDG6hhdlJrTuz..zCZ4_HXrrL0_NBtsfBZ35S43hnwLQoLNdDsUkoYT
 Okd6kiPmw3zOGaE_cAPquUmKqokzx.MgKv.qigo7o
X-Mailer: YahooMailWebService/0.8.121.416
References: <504B4F2D.40002@yahoo.com> <s5hligitcd0.wl%tiwai@suse.de>
Message-ID: <1347272938.6237.YahooMailNeo@web120301.mail.ne1.yahoo.com>
Date: Mon, 10 Sep 2012 03:28:58 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [alsa-devel] snd-intel-hda: screaming IRQ with 3.5.3 kernel (HDMI)
To: Takashi Iwai <tiwai@suse.de>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hligitcd0.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> Did you try any workaround boot options such as irqpoll, pci=nocrs or whatever?

No, because wouldn't "irqpoll" have forced polling for every IRQ on the box? I need to avoid polling on the video card's IRQ because it noticeably impacts the responsiveness. (I assume that the kernel switches to polling the device instead when it disables the IRQ anyway).


I didn't try "pci=nocrs" because I didn't know about it. I can try that tonight.

Cheers,
Chris

