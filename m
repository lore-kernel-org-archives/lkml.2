Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab1DMQLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:11:44 -0400
Received: from nm19.bullet.mail.bf1.yahoo.com ([98.139.212.178]:36624 "HELO
	nm19.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932563Ab1DMQLl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:11:41 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 794810.25196.bm@omp1040.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Tw2Pt9+ISpeFpE2zOkQZOnIyhNTKikH+UxtLUKXk/pFF4fk9FNeQDqMUvMWTRu2G191A7/gGWfxYPKJdMwjuN96OaQct7IgaKy4UTsvpoVeYwDnrmzT3XIHolZG9L4knP2wolVVx/HWMQDgwxi0k/1lqPFc02wWlgyr8ypM6hZ0=;
Message-ID: <677552.47001.qm@web161601.mail.bf1.yahoo.com>
X-YMail-OSG: BLXs2j8VM1lXp8JtBy9oxoYmk_ws_pNu7_5KVaLxKhWg0FX
 tW7Pc7s7uWHCG3Ettf46CzJgagrKYR7_GXO.5BypA4EhZS_1xkuuHVExBjIN
 dQq6J9zRVI4BHOyiWNXiKf2uFn8nCdKbUyJgNh24G6p5E3v_3.y6pXBuuAzh
 1v8lSksTIRpsDMZ9bQRBMboenLiJweiVb82dovVs9iO2mI0nSB9RE698HTtb
 eK4r3zs3o_HN7PA5z9qplZx_sJjS3k3328Xfjy1NrBWan2DwV4.ODECRYPLw
 j_LDSCmzMaNoa3M8Qtv2aOFkE9qafQUq7AQ7Y77n_YLXjnbAXZPBYECv64WJ
 dAhHH8o3c7Y.fetFhcVFNfqDTHYJqIym9IwmcmlIkkCSn9zlUPJF82A--
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.109.295617
Date: Wed, 13 Apr 2011 09:11:39 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: 2.6.38: rt2800usb: high latency (1000ms)?
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTi==Bw6mWWJidLi+ZRzz87ck4DAqVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I recall using this driver in staging and it crashing
> my machine, now thats
> > its no longer in staging, I thought I'd give it
> another try..  Using the
> 
> The rt2800usb was not in staging but has been inside the
> main kernel
> tree for quite
> some time already, the alternative rt2870sta was in staging
> and will
> be removed very soon.
> 
> > following wireless usb adapter, I'm seeing very high
> latency when using
> > the device in Linux, (with Windows, there are no
> problems).  Using Debian
> > Testing + wpa_supplicant, using the following USB
> adapter:
> 
> Can you try disabling powersaving?
> iwconfig wlan0 power off
> 
> Ivo

Hi,

I have exactly the same device /VID/. Ivo's suggestion fixed the problem, to some extent. Latency is fine now but every now and then I'd get (DUP!) duplicated packets and I've isolated the problem only to 54G capable APs. APs with 11n work fine without duplicate packets (or high latency).

My request is, will you please try pinging both G and N APs to see if duplicate packs are occurring at your end.

Walter
