Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1ITDfP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 23:35:15 -0400
Received: from nm27-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.244]:40780 "HELO
	nm27-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753771Ab1ITDfN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 23:35:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 569658.64738.bm@omp1052.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=eLG4lG0sX06/h890DQZXAo5a1QWupy6P+8yVnKTNMrnPbU5KM4I6GJzxhGoujZivJnE9UMRCQeo8GdrYfNuy3rwPQGNuotKqQaTe64Dr0R0iGAeDmHXkfgy9/4PhPWd0PZorX363fzBCZnd/OXEc8WJj2xE8Z7UeVjjtbc0KVDk=;
X-YMail-OSG: UUkNcKMVM1kpJgFBiCDCwnGofdAPQp186Yx8gjmtM2h7fba
 F2nTvP6NZQd99OqsGOcnG2.975dFtHpiDLMtg0y35k38ff0sjHiP2wfDNtlK
 qPwmGPmoITePWkL749bFWrn.YRhvifKjhXQpdauBumpdzpn9Thzp7vVPwJcR
 8fZRtxvrR4OCTP3H5i4aLALtIxl.e19JmL92DD.bR821qe.yAxw6KNyuaTEq
 gIXQswJYH9oOQucDXBUPdJYNDmJLeaP1OhOvTe6oe2kjn0d4Xl6oHhhg7qDo
 a_td7bUiHEGWDsmvha0awRIlIZ9Av9gfJvIpLL5ZZX9KP5bWnDE8dlKiVrkC
 cH0uakKVLiqWIgfS3FvtdsYnf02Tis.E1EbDniaJ6oi7ayxcq6xjWMg4Fv1q
 jjIgHjVFQi2opBl1mbWDPLLcKHCON5VN7KPydwmDbfvHgdc03yGsIBjrsz_v
 5DQ--
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1316478488.72684.YahooMailNeo@web130114.mail.mud.yahoo.com> <CAHR1FHH9bJScYkD7_gDaSd1JZ7eMai+x_-gzUtRZ5jmLSft_WA@mail.gmail.com>
Message-ID: <1316489711.61388.YahooMailNeo@web130108.mail.mud.yahoo.com>
Date: Mon, 19 Sep 2011 20:35:11 -0700 (PDT)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.
To: Pranjal Verma <tekytechllinux@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAHR1FHH9bJScYkD7_gDaSd1JZ7eMai+x_-gzUtRZ5jmLSft_WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From: Pranjal Verma <tekytechllinux@gmail.com>
>To: Alex Davis <alex14641@yahoo.com>
>Sent: Monday, September 19, 2011 11:26 PM
>Subject: Re: [Regression] Laptop screen dark when lid closed and reopened.
>
>
> i am facing the similar problem. I have opensuse11.4 with kernel 2.6.38. if i leave my laptop for sometime, its screen becomes dark and never brightens up. Then i have restart to continue  my work. Its really annoying. Any solution please.

Please send output from lspci -vv. Also what window environment are you using ( KDE, Gnome, etc).

And in future please use the 'reply all' function so the mailing list can see the response.

Thanks.
