Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab0HNRLZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 13:11:25 -0400
Received: from smtp149.mail.ukl.yahoo.com ([77.238.184.80]:31767 "HELO
	smtp149.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757179Ab0HNRLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 13:11:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=W/hm5akYOzNO7hI+BqR101WFKTA81JcXulE4bfxL5t7fX7ciyKVN1w2d2xG7VEDgEAQb4Rn3qvrlwigT+I4M7FZC2LqVszj09d6DWOWuU1az+HZGEXYCmYAmtDRilGxe10vaOt8xtUPs+IWm4OW1a0T5QYmGpSNLNiFMevMUIVg=  ;
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
X-YMail-OSG: ddlNsgAVM1lTGsEXEE2VGJNHwxzVq6YVimXg5NXCIMrdgzz
 lg1kd3bnZbCcqHBf9o_iJl7qWNikzqX3a0YTM7mIDkicCNlT38om9qiM2qg4
 lp1G4Uz4jcufWV.qp8cAmYWg_qoeLalmjm60Dj3z1SiD_1xdnIo5IpOxEcNB
 58WrfIyl2aKnphinSEIjThawu096Vh.eg7zNWqPdW7Yovqhzkz94d5OCMtvd
 U8r64D7ummA--
X-Yahoo-Newman-Property: ymail-3
From: Marek Lindner <lindner_marek@yahoo.de>
To: Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: batman-adv: design suggestions
Date: Sat, 14 Aug 2010 19:10:57 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: Sven Eckelmann <sven.eckelmann@gmx.de>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Linus =?iso-8859-1?q?L=FCssing?= <linus.luessing@web.de>
References: <20100809203403.GA16183@albatros> <201008141650.57375.lindner_marek@yahoo.de> <20100814161915.GB3258@albatros>
In-Reply-To: <20100814161915.GB3258@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008141910.58879.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 August 2010 18:19:15 Vasiliy Kulikov wrote:
> > Note: This document is neither complete nor up to date. Writing proper
> > documentation for the routing protocol is on our long ToDo list.
> 
> Do you plan to register it as RFC/IEEE/whatever when linux batman-adv
> implementation is stabilized? Or you plan to improve it somehow? :)

As you could see we already made the first "registration" attempt when we wrote 
the RFC draft. Unfortunately, we neither have the academic background nor the 
lobby to push things through. But help / ideas / etc are welcome. We are still 
very interested in seeing this happen.

We are constantly tweaking / improving the protocol which should not hinder 
such a standardization. 

Cheers,
Marek
