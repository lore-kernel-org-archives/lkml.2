Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0KKS1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:27:14 -0500
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:47943 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754231Ab0KKS1M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:27:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Nl46YxBgmZ/tLBGTsSkBbsXvgT0Gy6O89dtOYDu2anbz95lj+Zi+JNlq4Vpf6/K7fSWb2dEiqdcPKVljMZEC+KZvW1LWYnPaiguo6a5Pi0dkENFqTQeQxYjD8YW03rBBLE8zpnT3H/UtsjVHLSCzeoZsBY4MvXYX/nxjxdnxung=;
Message-ID: <673670.8195.qm@web31801.mail.mud.yahoo.com>
X-YMail-OSG: 99BYRPEVM1m13abKoLABTnKIV288GMchsiNLebJpJN3bo7H
 R4bz1_P7mtpz_fdjgaaztvEBnNDu.B8KaA4Se2F1c377lu1ItZJ3C5BYyjbK
 oTNZFjMrNkXqabvnbw7HrPk51z_3srlj6SNRN0qW1w1qK_pv9yH2EoER10wp
 FAqNR8lKXlMiI48CRYI5U4Fwl5SKsOEwK59lhtv4CFu66QP7LgW5js37PaNs
 QY4n6ruhyL90.J9RmVDNi81Z89azte6aivqUItYF1Os9v_3mBoaCYP1e6jGD
 PTsU9WE9jp_cYWjKDtFL0Sq3d3E4bDtTjCqrsyg.KsAh0z.ViF7ShkJ0IsoK
 D_SQIXwFjcgOE.6_KvOdwHRCBTA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Thu, 11 Nov 2010 10:27:11 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101111174322.GB20296@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 11/11/10, Matthew Dharm <mdharm-kernel@one-eyed-alien.net> wrote:
> On Thu, Nov 11, 2010 at 09:07:53AM -0800, Luben Tuikov wrote:
> > 
> > Oh, I see. I'll re-post the patch then to Matthew and
> the people and lists you listed above.
> 
> Now that I'm on the CC, I see this.
> 
> What's the 10k-foot level summary here?

I'm not sure either. It's apparently the procedure of getting a patch into the linux kernel nowadays. Last time I did this was 5 years ago and in linux-scsi--I remember it being easier, again that was 5 years ago.

> Is there an alternate sense-data format that uses some sort of "descriptor" structure?

Yes. Some devices return this format of sense data for some commands.

> I'm assuming this is
> a new SCSI-III thing, or did I just miss it in SCSI-II?
> This *looks* like you're using functions provided by the
> SCSI core to
> access and modify the sense data... so I'm assuming that's
> because there
> are alternate formats...

The patch doesn't add code that modifies the sense data. That modification code is already there, the patch fixes the modification which assumed only one type of format of sense data.

The patch uses SCSI functions to abstract the sense information irrespective of the type of format of sense data.

> 
> Matt
> 
> -- 
> Matthew Dharm           
>                
>   Home: mdharm-usb@one-eyed-alien.net
> 
> Maintainer, Linux USB Mass Storage Driver
> 
> It was a new hope.
>            
>         -- Dust Puppy
> User Friendly, 12/25/1998
> 
