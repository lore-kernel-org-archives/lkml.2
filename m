Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab0KKQtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:49:55 -0500
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:47775 "HELO
	web31804.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754504Ab0KKQtx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 11:49:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=4TkZTdwYYzsvAddykMp3RwyFlebdk5yw9AyERlXs+ABgxq1A3mnAlpFlD+J3GBGYSPr71Yz/rq1dlDd3JjIT72W3PnV3o/D5xsNVrHKyWM7CmsjeeuxkkOD7ZFAX1Evmd3jK+te3f72v1u6qlgIbaezrCSXGFcBqumgY01kSzSs=;
Message-ID: <892012.17950.qm@web31804.mail.mud.yahoo.com>
X-YMail-OSG: tn1BarYVM1nhOi5cpAv4gfYRH8I9n3J926l9Qid6b0af85i
 396CIHtcklWeafZyO00UYM0A193JyQ4WP4FhPUvxj4DWMeE2F9wyXLbT_X2c
 nnTaTq1WLR.X1666iQCbjETnWceveikls1SPrfccEIzjBejz61XiKjCtnYIv
 vsIxdTRqVK7kMmNzDP3CvArMl3N4UCjau2kYmIUbwIwkIlA5CQWrgK31smT2
 szCGgjw0bYe1.XaWxDgzac2jcrJOsGzm23pFw0NQsWDI8gaZTNYggKIRGZrU
 hDhoVsGqR.lfkq0795Zqq4bHaUgvjfRFtiTAet7s1DL2uClUzenN1iyPjy6C
 o3K0dIhQx6LpEqXImkaNd4c2D2CXfvaqyAA--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Thu, 11 Nov 2010 08:49:51 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH take 2] [USB] Use normalized sense when emulating autosense
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101111134450.GB12291@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 11/11/10, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 22, 2010 at 02:12:51PM
> -0700, Luben Tuikov wrote:
> > This patch solves two things:
> > 1) Enables autosense emulation code to correctly
> > interpret descriptor format sense data, and
> > 2) Fixes a bug whereby the autosense emulation
> > code would overwrite descriptor format sense data
> > with SENSE KEY HARDWARE ERROR in fixed format, to
> > incorrectly look like this:
> > 
> > Oct 21 14:11:07 localhost kernel: sd 7:0:0:0:
> [sdc]  Sense Key : Recovered Error [current]
> [descriptor]
> > Oct 21 14:11:07 localhost kernel: Descriptor sense
> data with sense descriptors (in hex):
> > Oct 21 14:11:07 localhost kernel:     
>   72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> > Oct 21 14:11:07 localhost kernel:     
>   00 4f 00 c2 00 50
> > Oct 21 14:11:07 localhost kernel: sd 7:0:0:0:
> [sdc]  ASC=0x4 ASCQ=0x1d
> > 
> > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> 
> I need to get the ack from the usb-storage
> maintainer.  Can you get that
> so that I can apply this?

Hi Greg,

I don't know who the usb-storage maintainer is, as I've mostly contributed to linux-scsi. Do you? I know Alan acked this patch. Is it him? Any reason you didn't CC the usb-storage maintainer in this email?  Can you reply back to this thread CC-ing him? The only email I have in my address book is yours.

Thank you for being so nice and patient in this long, difficult, arduous and intimidating[1] process.

   Luben
[1]linux-2.6/Documentation/development-process/6.Followthrough:22:
"Working with reviewers can be, for many developers, the most intimidating part of the kernel development process."

