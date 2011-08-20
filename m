Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1HTOqq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 10:46:46 -0400
Received: from mail.neratec.ch ([80.75.119.105]:53100 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab1HTOqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 10:46:45 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Aug 2011 10:46:45 EDT
Date: Sat, 20 Aug 2011 16:38:16 +0200 (CEST)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>
Message-ID: <1324190381.8502.1313851096075.JavaMail.root@idefix>
In-Reply-To: <CAFtRNNwMBnd6CVJn9UYSu58E-EpAS7p0Qh=ZtfJHfdtS-wKxjg@mail.gmail.com>
Subject: Re: Linux wireless summit videoes from LinuxCon 2011
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [206.191.100.2]
X-Mailer: Zimbra 6.0.13_GA_2918 (ZimbraWebClient - FF3.0 (Mac)/6.0.13_GA_2918)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slides for the DFS presentation are available at
http://linuxwireless.org/en/developers/DFS#Related_Information


Zefir
----- Ursprüngliche Mail -----
> Von: "Nick Kossifidis" <mickflemm@gmail.com>
> An: "Luis R. Rodriguez" <mcgrof@gmail.com>
> CC: "linux-wireless" <linux-wireless@vger.kernel.org>, linux-kernel@vger.kernel.org
> Gesendet: Samstag, 20. August 2011 10:36:03
> Betreff: Re: Linux wireless summit videoes from LinuxCon 2011
> 2011/8/20 Luis R. Rodriguez <mcgrof@gmail.com>:
> > For those that could not make it to the 2011 Linux wireless summit
> > at
> > LinuxCon Vancouver we have up 3 videoes on YouTube:
> >
> > 1) [RFC] 802.11 DFS design on mac80211 / ath9k
> >
> > http://www.youtube.com/watch?v=_yyFiLFx4Mg
> >
> > Saxnet present their latest effort on design for a DFS architecture
> > for mac80211 and for ath9k. This is from LinuxCon 2011 this week.
> > Saxnet did an awesome job. If this design works for certification it
> > could mean lowering the entry price for AP vendors looking to pass
> > DFS
> > testing. This work is under review now.
> >
> > 2) 802.11s on LInux mac80211
> >
> > 802.11s Mesh Networking was ratified by IEEE for integration into
> > 802.11. Javier Cardona has been leading its implementation and
> > support
> > on mac80211. In this session he reviews 802.11s with open and
> > encrypted environments. 802.11s uses a different encryption
> > algorithm
> > called "simultaneous authentication of equals", Javier reviews work
> > needed to integrate the userspace application required supporting
> > this
> > encryption mechanism on hostapd / wpa_supplicant.
> >
> > 3) wmediumd for mac80211_hwsim
> >
> > Javier Cardona explains what Cozybit used to test the 802.11s code
> > implemented in mac80211. He used extensions to mac80211_hwsim that
> > allow links to be lossy. Cozybit also wrote a daemon to communicate
> > to
> > mac80211_hwsim to statically or dynamically alter the
> > characteristics
> > of the links. Right now mac80211_hwsim only accounts for packet loss
> > between links but extensions can be made to also add latency later.
> > He
> > also demos a Java application used to create your topology for
> > mac80211_hwsim. Researchers should get a chubby with this framework
> > --
> > you can extend this to do really cool shit, all in software with no
> > hardware.
> >
> > --
> >
> > Kudos to Saxnet and Cozybit for their presentations and *awesome*
> > work
> > on coding up stuff and doing a great job at explaining all this to
> > us.
> >
> > Nothing else was recorded, sorry :) If you loose the links you'll be
> > able to find them here:
> >
> > http://wireless.kernel.org/en/users/Documentation#YouTube_Documentation
> >
> >  Luis
> 
> Thanks a lot !
> 
> Is it possible to have the presentations uploaded on the wiki also ?
> 
> 
> 
> --
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
